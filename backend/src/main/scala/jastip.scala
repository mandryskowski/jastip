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
        val auctions = TableQuery[Auctions]
        val auctionsFuture: Future[Seq[Auction]] = db.run(auctions.result)
        onSuccess(auctionsFuture) { auctionsList =>
          complete(auctionsList.map(_.toString).mkString(", "))
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
    path("auctions-json") {
      get {
        val auctions = TableQuery[Auctions]
        val auctionsFuture: Future[Seq[Auction]] = db.run(auctions.result)
        onSuccess(auctionsFuture) { auctionsList =>
          complete(auctionsList)
        }
      }
    } ~
    path("auctions-json-modified") {
      get {
        val auctionsQuery = TableQuery[Auctions]
        val bidsQuery = TableQuery[Bids]

        val joinedQuery = for {
          (auction, bid) <- auctionsQuery joinLeft bidsQuery on (_.auctionId === _.auctionId)
        } yield (auction, bid.map(_.price))

        val auctionsWithPricesQuery = joinedQuery.result.map { result =>
          result.groupBy(_._1).map { case (auction, bids) =>
            AuctionWithPrices(
              auction.auctionId,
              auction.userId,
              auction.length,
              auction.width,
              auction.height,
              auction.fragile,
              auction.description,
              auction.departure,
              auction.arrival,
              auction.auctionEnd,
              auction.startingPrice,
              bids.flatMap(_._2).toList
            )
          }.toSeq
        }

        val auctionsWithPricesFuture: Future[Seq[AuctionWithPrices]] = db.run(auctionsWithPricesQuery)
        onSuccess(auctionsWithPricesFuture) { auctionsList =>
          complete(auctionsList)
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