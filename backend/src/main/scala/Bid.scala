import MyPostgresProfile.api._


case class Bid(bidId : Long, auctionId: Long, userId: Int, price: Double, date: java.sql.Timestamp)
class Bids(tag: Tag) extends Table[Bid](tag, "bids") {
  def bidId = column[Long]("bid_id", O.PrimaryKey, O.AutoInc)
  def userId = column[Int]("user_id")
  def auctionId = column[Long]("auction_id")
  def price = column[Double]("price")
  def date = column[java.sql.Timestamp]("date")

  def * = (bidId, auctionId, userId, price, date) <> (Bid.tupled, Bid.unapply)
}

import BidJsonProtocol._