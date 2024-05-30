import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport._
import spray.json.DefaultJsonProtocol._
import Auction._
import MyJsonProtocol._


object AuctionJsonProtocol extends spray.json.DefaultJsonProtocol {
  implicit val auctionFormat = jsonFormat14(Auction)
}