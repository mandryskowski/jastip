import MyPostgresProfile.api._

case class Auction(auctionId: Long, userId: Int, length: Float, width: Float, height: Float, fragile: Boolean,
                   description: String, departure: java.sql.Timestamp, arrival: java.sql.Timestamp,
                   auctionEnd: java.sql.Timestamp, startingPrice: Double, bids: List[Long])

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
  def bids = column[List[Long]]("bid_id")

  def * = (auctionId, userId, length, width, height, fragile, description, departure, arrival, auctionEnd,
    startingPrice, bids) <> (Auction.tupled, Auction.unapply)
}