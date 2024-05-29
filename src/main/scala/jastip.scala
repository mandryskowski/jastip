import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model.StatusCodes
import akka.http.scaladsl.server.Directives._
import slick.jdbc.PostgresProfile.api._
import scala.concurrent.Future
import scala.io.StdIn
import scala.util.{Failure, Success}
import com.typesafe.config.ConfigFactory

case class User(id: Int, username: String)

class Users(tag: Tag) extends Table[User](tag, "users") {
  def id = column[Int]("id", O.PrimaryKey, O.AutoInc)
  def username = column[String]("username")
  def * = (id, username) <> (User.tupled, User.unapply)
}

object Main extends App {
  implicit val system: ActorSystem = ActorSystem("my-system")
  implicit val executionContext = system.dispatcher

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
    path("android") {
      get {
        redirect("https://" + androidFile, StatusCodes.PermanentRedirect)
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