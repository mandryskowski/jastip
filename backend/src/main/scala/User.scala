import MyPostgresProfile.api._
import BidJsonProtocol._
import scala.concurrent.{Future, Await}
import akka.http.scaladsl.server.Directives._
import scala.concurrent.ExecutionContext
import Review._


case class User(id: Int, username: String)

case class UserInfo(id: Int, username: String, ratings: Int, averageRating: Double)

case class Credentials(username: String)

class Users(tag: Tag) extends Table[User](tag, "users") {
  def id = column[Int]("id", O.PrimaryKey, O.AutoInc)
  def username = column[String]("username")
  def * = (id, username) <> (User.tupled, User.unapply)
}


class UserRepository(db: Database)(implicit ec: ExecutionContext) {
  val users = TableQuery[Users]
  val reviews = TableQuery[Reviews]

  def getUserInfo(id: Int): Future[Option[UserInfo]] = {
    val query = for {
      (user, review) <- users.filter(_.id === id) joinLeft reviews on (_.id === _.about)
    } yield (user, review)

    db.run(query.result).map { result =>
      if (result.isEmpty) None
      else {
        val (user, userReviews) = result.unzip
        val filteredReviews = userReviews.filter(_.isDefined).map(_.get)
        val reviewCount = filteredReviews.size
        val averageRating = if (reviewCount > 0) filteredReviews.map(_.rating).sum.toDouble / reviewCount else 0.0
        Some(UserInfo(user.head.id, user.head.username, reviewCount, averageRating))
      }
    }
  }

  def getUsersInfo(): Future[Seq[UserInfo]] = {
    val query = for {
      (user, review) <- users joinLeft reviews on (_.id === _.about)
    } yield (user, review)

    db.run(query.result).map { result =>
      result.map {  case (user, userReviews) =>
        val reviewCount = userReviews.size
        val averageRating = if (reviewCount > 0) userReviews.map(_.rating).sum.toDouble / reviewCount else 0.0
        UserInfo(user.id, user.username, reviewCount, averageRating)
      }
    }
  }
}