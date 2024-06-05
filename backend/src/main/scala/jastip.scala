import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model._
import akka.http.scaladsl.server.Directives._
import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport._
import akka.http.scaladsl.unmarshalling.Unmarshal
import akka.http.scaladsl.client.RequestBuilding.Get
import scala.concurrent.{Await, Future}
import scala.concurrent.duration.Duration
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
import java.time.Instant
import spray.json.JsonFormat

object JastipBackend extends App {
  implicit val system: ActorSystem = ActorSystem("my-system")
  implicit val executionContext = system.dispatcher
  val config = ConfigFactory.load()

  val db = Database.forConfig("databaseUrl")
  val auctionRepository = new AuctionRepository(db)

  val users = TableQuery[Users]
  val bids = TableQuery[Bids]

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
        } ~
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
    path("bids") {
      get {
        val bidsFuture: Future[Seq[Bid]] = db.run(bids.result)
        onSuccess(bidsFuture) { bidsList =>
          complete(bidsList) // Automatically converts to JSON
        }
      } ~
      post {
        entity(as[PostBid]) { bidRequest =>
          val currentTimestamp = Timestamp.from(Instant.now())
          val newBid = Bid(0L, bidRequest.auctionId.toLong, bidRequest.userId.toInt, bidRequest.price.toDouble, currentTimestamp)

          val auctionsFuture: Future[Seq[AuctionWithPrices]] = auctionRepository.filterAuctions(Map.empty, 10000)
          onSuccess(auctionsFuture) { auctionsBids =>
            auctionsBids.find(_.auctionId == bidRequest.auctionId.toLong) match {
              case Some(auction) => {
                if (auction.startingPrice >= bidRequest.price.toDouble)
                  complete(StatusCodes.BadRequest, "Bid must be higher than starting price")
                else if (auction.bidPrices.last >= bidRequest.price.toDouble)
                  complete(StatusCodes.BadRequest, "Bid must be higher than highest bid")
                else {
                  val insertAction = (bids returning bids.map(_.bidId) into ((bid, id) => bid.copy(bidId = id))) += newBid

                  onComplete(db.run(insertAction).flatMap { bid =>
                    auctionRepository.updateAuctionBids(bid.auctionId, bid.bidId.toInt).map(_ => bid)
                  }) {
                    case Success(bid) => complete(bid)
                    case Failure(ex) => complete((StatusCodes.InternalServerError, s"An error occurred: ${ex.getMessage}"))
                  }
                }
              }

              case None => complete(StatusCodes.BadRequest, s"Auction with id ${bidRequest.auctionId} does not exist")
            }
          }
        }
      }
    } ~
    path("auctions/count") {
      get {
        extract(_.request.uri.query()) { params =>
          val auctionsFuture = auctionRepository.filterAuctions(params.toMap, 100)
          onSuccess(auctionsFuture) { auctionsList =>
            complete(s"${auctionsList.length}")
          }
        }
      }
    } ~
    path("locations") {
      get {
        val req : Future[HttpResponse] = Http().singleRequest(Get("https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/geonames-all-cities-with-a-population-1000/records?select=geoname_id%2C%20name%2C%20cou_name_en%2C%20coordinates&where=name%20LIKE%20%22%25London%25%22&order_by=population%20DESC&limit=20"))

        onComplete(req) {
          case Success(res) =>
            onComplete(Unmarshal(res.entity).to[ApiResponse]) {
              case Success(apiResponse) =>
                complete(apiResponse.results)
              case Failure(_) =>
                complete(StatusCodes.InternalServerError, "Failed to unmarshal API response")
            }
          case Failure(_) =>
            complete(StatusCodes.InternalServerError, "Failed to fetch API response")
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