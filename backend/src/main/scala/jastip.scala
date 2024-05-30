import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model.StatusCodes
import akka.http.scaladsl.server.Directives._
import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport._
import scala.concurrent.Future
import scala.io.StdIn
import scala.util.{Failure, Success}
import scala.concurrent.ExecutionContext.Implicits.global
import scala.collection.Seq
import com.typesafe.config.ConfigFactory
import MyPostgresProfile.api._
import BidJsonProtocol._
import slick.lifted.{ProvenShape, TableQuery}
import java.sql.Timestamp
import java.sql.Date
import java.time.LocalDate

object Main extends App {
  implicit val system: ActorSystem = ActorSystem("my-system")
  implicit val executionContext = system.dispatcher
  val config = ConfigFactory.load()

  val db = Database.forConfig("databaseUrl")

  val users = TableQuery[Users]

  val route =
    path("users") {
      get {
        val usersFuture: Future[Seq[User]] = db.run(users.result)
        onSuccess(usersFuture) { usersList =>
          complete(usersList.map(_.toString).mkString(", "))
        }
      } ~
      post {
        entity(as[String]) { username =>
          val insertAction = (users.map(_.username) returning users.map(_.id)) += username
          onSuccess(db.run(insertAction)) { id =>
            complete(StatusCodes.Created, s"User created with id: $id")
          }
        }
      }
    } ~
    path("auctions") {
      get {
        extract(_.request.uri.query()) { params =>

          val initialQuery = TableQuery[Auctions].take(params.get("limit").map(_.toInt).getOrElse(100))

          val filters: Seq[(String, Auctions => String => Rep[Boolean])] = Seq(
            "fragile" -> ((auction: Auctions) => (v: String) => (auction.fragile === true) || (auction.fragile === (v == "true"))),
            "startCity" -> ((auction: Auctions) => (v: String) => auction.from.toLowerCase === v.toLowerCase),
            "endCity" -> ((auction: Auctions) => (v: String) => auction.to.toLowerCase === v.toLowerCase),
            "endDate" -> ((auction: Auctions) => (v: String) => {
                val date = Timestamp.valueOf(LocalDate.parse(v).plusDays(1).atStartOfDay())
                auction.auctionEnd.between(Timestamp.from(date.toInstant().minusSeconds(86400 * 30)), date)
            }),
            "length" -> ((auction: Auctions) => (v: String) => auction.length >= v.toFloat),
            "width" -> ((auction: Auctions) => (v: String) => auction.width >= v.toFloat),
            "height" -> ((auction: Auctions) => (v: String) => auction.height >= v.toFloat)
          )

          val filteredQuery = filters.foldLeft(initialQuery) { case (query, (paramName, filterFunc)) =>
            params.get(paramName) match {
              case Some(value) => query.filter(filterFunc(_)(value))
              case None => query
            }
          }


          val auctionsQuery = filteredQuery
          val bidsQuery = TableQuery[Bids]

          val joinedQuery = for {
            (auction, bid) <- auctionsQuery joinLeft bidsQuery on (_.auctionId === _.auctionId)
          } yield (auction, bid.map(_.price))

          val auctionsWithPricesQuery = joinedQuery.sortBy(_._1.auctionId).result.map { result =>
            result.groupBy(_._1).map { case (auction, bids) =>
              AuctionWithPrices(
                auction.auctionId,
                auction.userId,
                auction.length,
                auction.width,
                auction.height,
                auction.fragile,
                auction.description,
                auction.from,
                auction.to,
                auction.departure,
                auction.arrival,
                auction.auctionEnd,
                auction.startingPrice,
                bids.flatMap(_._2).toList
              )
            }.toSeq
          }

          val auctionsWithPricesFuture: Future[Seq[AuctionWithPrices]] = db.run(auctionsWithPricesQuery)
          val sortedAuctionsWithPricesFuture = (params.get("orderedBy") match {
            case Some("date") => auctionsWithPricesFuture.map(_.sortBy(_.auctionEnd).reverse)
            case Some("size") => auctionsWithPricesFuture.map(_.sortBy(_.length).reverse)
            case _ => auctionsWithPricesFuture.map(_.sortBy(_.auctionId).reverse)
          }) 
          onSuccess(sortedAuctionsWithPricesFuture) { auctionsList =>
            complete(auctionsList)
          }
        }
      } ~
      post {
        entity(as[PostAuction]) { auctionWithoutId =>
          val auctions = TableQuery[Auctions]
          val auctionToInsert = Auction(0, 1, auctionWithoutId.length, auctionWithoutId.width,
            auctionWithoutId.height, auctionWithoutId.fragile, auctionWithoutId.description, auctionWithoutId.from, auctionWithoutId.to, auctionWithoutId.departure,
            auctionWithoutId.arrival, auctionWithoutId.auctionEnd, auctionWithoutId.startingPrice, List.empty)
          val insertAuctionFuture: Future[Long] = db.run((auctions returning auctions.map(_.auctionId)) += auctionToInsert)
          onSuccess(insertAuctionFuture) { auctionId =>
            complete(StatusCodes.Created, s"Auction created with ID: $auctionId")
          }
        }
      }
    } ~
    path("android") {
      get {
        redirect("https://" + config.getString("bucket") + ".s3.amazonaws.com/public/jastip.apk", StatusCodes.PermanentRedirect)
      }
    } ~
    path("ios") {
      get {
        complete("Coming soon! :)")
      }
    } ~
    path("bids-json") {
      get {
        val bids = TableQuery[Bids]
        val bidsFuture: Future[Seq[Bid]] = db.run(bids.result)
        onSuccess(bidsFuture) { bidsList =>
          complete(bidsList) // Automatically converts to JSON
        }
      }
    } ~
    path("bids") {
      get {
        val bids = TableQuery[Bids]
        val bidsFuture: Future[Seq[Bid]] = db.run(bids.result)
        onSuccess(bidsFuture) { bidsList =>
          complete(bidsList.map(_.toString).mkString(", "))
        }
      }
    }

  val port = sys.env.getOrElse("PORT", "8080").toInt
  val bindingFuture = Http().newServerAt("0.0.0.0", port).bind(route)

  bindingFuture.onComplete {
    case Success(binding) =>
      println(s"Server online at http://localhost:${binding.localAddress.getPort}/")
    case Failure(exception) =>
      println(s"Failed to bind HTTP server: ${exception.getMessage}")
      system.terminate()
  }

  sys.addShutdownHook {
    bindingFuture
      .flatMap(_.unbind())
      .onComplete { _ =>
        system.terminate()
      }
  }
}