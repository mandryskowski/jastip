import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport._
import spray.json.DefaultJsonProtocol._
import Bid._
import Auction._
import MyJsonProtocol._


object BidJsonProtocol extends spray.json.DefaultJsonProtocol {
  implicit val bidFormat = jsonFormat5(Bid)
  implicit val auctionFormat = jsonFormat12(Auction)
  implicit val auctionWithPricesFormat = jsonFormat12(AuctionWithPrices)
}