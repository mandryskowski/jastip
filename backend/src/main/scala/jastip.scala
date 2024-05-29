import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model.StatusCodes
import akka.http.scaladsl.server.Directives._
import slick.jdbc.PostgresProfile.api._
import slick.lifted.ProvenShape
import scala.concurrent.Future
import scala.io.StdIn
import scala.util.{Failure, Success}
import scala.concurrent.ExecutionContext.Implicits.global
import scala.collection.Seq
import com.typesafe.config.ConfigFactory

object Main extends App {

  case class User(id: Int, username: String)

  class Users(tag: Tag) extends Table[User](tag, "users") {
    def id = column[Int]("id", O.PrimaryKey, O.AutoInc)
    def username = column[String]("username")
    def * = (id, username) <> (User.tupled, User.unapply)
  }

  case class Auction(auctionId: Long, userId: Int, length: Float, width: Float, height: Float, fragile: Boolean,
                    description: String, departure: java.sql.Timestamp, arrival: java.sql.Timestamp,
                    auctionEnd: java.sql.Timestamp, startingPrice: Double, bids: List[Double], bid_users: List[Double])

  implicit val doubleListColumnType: MappedColumnType[List[Double], String] =
    MappedColumnType.base[List[Double], String](
      list => list.mkString(","),
      str => str.split(",").toList.map(_.toDouble)
    )

  class Auctions(tag: Tag) extends Table[Auction](tag, "auctions") {
    def auctionId = column[Long]("auction_id", O.PrimaryKey, O.AutoInc)
    def userId = column[Int]("user_id")
    def length = column[Float]("length")
    def width = column[Float]("width")
    def height = column[Float]("height")
    def fragile = column[Boolean]("fragile")
    def description = column[String]("description")
    def departure = column[java.sql.Timestamp]("departure")
    def arrival = column[java.sql.Timestamp]("arrival")
    def auctionEnd = column[java.sql.Timestamp]("auction_end")
    def startingPrice = column[Double]("starting_price")
    def bids = column[List[Double]]("bids")
    def bid_users = column[List[Double]]("bid_users")

    def * = (auctionId, userId, length, width, height, fragile, description, departure, arrival, auctionEnd,
      startingPrice, bids, bid_users) <> (Auction.tupled, Auction.unapply)
  }

  implicit val system: ActorSystem = ActorSystem("my-system")
  implicit val executionContext = system.dispatcher
  val config = ConfigFactory.load()

  val db = Database.forConfig("databaseUrl")

  val users = TableQuery[Users]
  val auctions = TableQuery[Auctions]

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
    path("auctions") {
      get {
        val auctionsFuture: Future[Seq[Auctions]] = db.run(auctions.result)
        onSuccess(auctionsFuture) { auctionsList =>
          complete(auctionsList.map(_.toString).mkString(", "))
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