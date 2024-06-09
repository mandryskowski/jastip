import MyPostgresProfile.api._
import java.sql.Timestamp

// Define the case class
case class Review(
  reviewId: Option[Int] = None, // Option to allow auto-incremented IDs
  auctionId: Int,
  author: Int,
  about: Int,
  rating: Int,
  content: String,
  timestamp: Timestamp
)

case class PostReviewStr(
  auctionId: String,
  author: String,
  about: String,
  rating: String,
  content: String
)

// Define the Table schema
class Reviews(tag: Tag) extends Table[Review](tag, "reviews") {
  // Define the columns
  def reviewId = column[Int]("review_id", O.PrimaryKey, O.AutoInc)
  def auctionId = column[Int]("auction_id")
  def author = column[Int]("author")
  def about = column[Int]("about")
  def rating = column[Int]("rating")
  def content = column[String]("content")
  def timestamp = column[Timestamp]("timestamp", O.Default(new Timestamp(System.currentTimeMillis())))

  // Define the * projection (shape of the case class)
  def * = (reviewId.?, auctionId, author, about, rating, content, timestamp) <> ((Review.apply _).tupled, Review.unapply)
}