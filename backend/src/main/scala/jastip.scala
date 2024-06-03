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

object JastipBackend extends App {
  implicit val system: ActorSystem = ActorSystem("my-system")
  implicit val executionContext = system.dispatcher
  val config = ConfigFactory.load()

  val db = Database.forConfig("databaseUrl")
  val auctionRepository = new AuctionRepository(db)

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
          val limit = params.get("limit").map(_.toInt).getOrElse(100)
          val auctionsFuture = auctionRepository.filterAuctions(params.toMap, limit)
          val sortedAuctionsFuture = (params.get("orderedBy") match {
            case Some("date") => auctionsFuture.map(_.sortBy(_.auctionEnd).reverse)
            case Some("size") => auctionsFuture.map(_.sortBy(_.length).reverse)
            case _ => auctionsFuture.map(_.sortBy(_.auctionId).reverse)
          })
          onSuccess(sortedAuctionsFuture) { auctionsList =>
            complete(auctionsList)
          }
        }
      } ~
      post {
        entity(as[PostAuction]) { postAuction =>
          val auctionToInsert = Auction(
            0, 1, postAuction.length, postAuction.width, postAuction.height, postAuction.weight,
            postAuction.fragile, postAuction.description, postAuction.from, postAuction.to,
            postAuction.departure, postAuction.arrival,
            Timestamp.from(postAuction.departure.toInstant().minusSeconds(86400 * postAuction.daysBefore)), postAuction.startingPrice, List.empty
          )
          auctionRepository.verifyAuction(auctionToInsert) match {
            case Some(reason) => complete(StatusCodes.BadRequest, reason)
            case _ =>
              val insertAuctionFuture = auctionRepository.insert(auctionToInsert)
              onSuccess(insertAuctionFuture) { auctionId =>
                complete(StatusCodes.Created, s"Auction created with ID: $auctionId")
              }
          }
        }
        entity(as[PostAuctionStr]) { postAuction =>
          val auctionToInsert = Auction(0, 1, postAuction.length.toFloat, postAuction.width.toFloat,
            postAuction.height.toFloat, postAuction.weight.toFloat, postAuction.fragile.toBoolean, postAuction.description, postAuction.from, postAuction.to, postAuction.departure,
            postAuction.arrival, Timestamp.from(postAuction.departure.toInstant().minusSeconds(86400 * postAuction.daysBefore.toInt)), postAuction.startingPrice.toDouble, List.empty)
            
          auctionRepository.verifyAuction(auctionToInsert) match {
            case Some(reason) => complete(StatusCodes.BadRequest, reason)
            case _ =>
              val insertAuctionFuture = auctionRepository.insert(auctionToInsert)
            onSuccess(insertAuctionFuture) { auctionId =>
              complete(StatusCodes.Created, s"Auction created with ID: $auctionId")
            }
          }

          
        }
      }
    } ~
    path("suggestions") {
      get {
          extract(_.request.uri.query()) { params =>
          val limit = params.get("limit").map(_.toInt).getOrElse(100)
          val suggestionsFuture = auctionRepository.suggestions(params.toMap, limit)
          onSuccess(suggestionsFuture) { auctionsList =>
            complete(auctionsList)
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