import MyPostgresProfile.api._

case class Auction(auctionId: Long, userId: Int, length: Float, width: Float, height: Float, weight : Float, fragile: Boolean,
                   description: String, from : String, to : String, departure: java.sql.Timestamp, arrival: java.sql.Timestamp,
                   auctionEnd: java.sql.Timestamp, startingPrice: Double, bids: List[Int])

case class PostAuction(length: Float, width: Float, height: Float, weight : Float, fragile: Boolean,
                    description: String, from : String, to : String, departure: java.sql.Timestamp, arrival: java.sql.Timestamp,
                    startingPrice: Double, daysBefore : Int)

case class PostAuctionStr(length: String, width: String, height: String, weight : String, fragile: String,
                    description: String, from : String, to : String, departure: java.sql.Timestamp, arrival: java.sql.Timestamp,
                    startingPrice: String, daysBefore : String)

case class AuctionWithPrices(
  auctionId: Long,
  userInfo: UserInfo,
  length: Float,
  width: Float,
  height: Float,
  weight : Float,
  fragile: Boolean,
  description: String,
  from : String,
  to : String,
  departure: java.sql.Timestamp,
  arrival: java.sql.Timestamp,
  auctionEnd: java.sql.Timestamp,
  startingPrice: Double,
  bidPrices: List[Double],
  bids: List[Long]
)

case class Address(
  address_id: Int,
  auction_id: Int,
  name: String,
  line1: String,
  line2: String,
  city: String,
  postal: String
)

case class PostAddress(
  auction_id: String,
  name: String,
  line1: String,
  line2: String,
  city: String,
  postal: String
)

case class AuctionWithPricesAndWinnerId(
  auctionId: Long,
  userInfo: UserInfo,
  length: Float,
  width: Float,
  height: Float,
  weight : Float,
  fragile: Boolean,
  description: String,
  from : String,
  to : String,
  departure: java.sql.Timestamp,
  arrival: java.sql.Timestamp,
  auctionEnd: java.sql.Timestamp,
  startingPrice: Double,
  bidPrices: List[Double],
  bids: List[Long],
  winner: UserInfo,
  hasReview: Boolean,
  address: Option[Address]
)

class Auctions(tag: Tag) extends Table[Auction](tag, "auctions") {
  def auctionId = column[Long]("auction_id", O.PrimaryKey, O.AutoInc)
  def userId = column[Int]("user_id")
  def length = column[Float]("length")
  def width = column[Float]("width")
  def height = column[Float]("height")
  def weight = column[Float]("weight")
  def fragile = column[Boolean]("fragile")
  def description = column[String]("description")
  def departure = column[java.sql.Timestamp]("departure_time")
  def arrival = column[java.sql.Timestamp]("arrival_time")
  def from = column[String]("departure_city")
  def to = column[String]("arrival_city")
  def auctionEnd = column[java.sql.Timestamp]("auction_end")
  def startingPrice = column[Double]("starting_price")
  def bids = column[List[Int]]("bid_ids")

  def * = (auctionId, userId, length, width, height, weight, fragile, description, from, to, departure, arrival, auctionEnd,
    startingPrice, bids) <> (Auction.tupled, Auction.unapply)
}

class Addresses(tag: Tag) extends Table[Address](tag, "addresses") {
  def addressId = column[Int]("address_id", O.PrimaryKey, O.AutoInc)
  def auctionId = column[Int]("auction_id")
  def name      = column[String]("name")
  def line1     = column[String]("line1")
  def line2     = column[String]("line2")
  def city      = column[String]("city")
  def postal    = column[String]("postal_code")

  def * = (addressId, auctionId, name, line1, line2, city, postal) <> (Address.tupled, Address.unapply)
}


import BidJsonProtocol._