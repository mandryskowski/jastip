import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport._
import spray.json.DefaultJsonProtocol._
import Bid._
import Auction._
import MyJsonProtocol._

final case class Coordinates(lon: Double, lat: Double)
final case class Result(geoname_id: String, name: String, cou_name_en: String, coordinates: Coordinates)
final case class ApiResponse(total_count: Int, results: List[Result])


object BidJsonProtocol extends spray.json.DefaultJsonProtocol {
  implicit val bidFormat = jsonFormat5(Bid)
  implicit val postBidFormat = jsonFormat3(PostBid)
  implicit val auctionFormat = jsonFormat15(Auction)
  implicit val auctionWithPricesFormat = jsonFormat16(AuctionWithPrices)
  implicit val auctionWithPricesAndWinnerIdFormat = jsonFormat17(AuctionWithPricesAndWinnerId)
  implicit val postAuctionFormat = jsonFormat12(PostAuction)
  implicit val postAuctionStrFormat = jsonFormat12(PostAuctionStr)

  implicit val userFormat = jsonFormat2(User)
  implicit val credentialsFormat = jsonFormat1(Credentials)

  // locations
  implicit val coordinatesFormat = jsonFormat2(Coordinates)
  implicit val resultFormat = jsonFormat4(Result)
  implicit val apiResponseFormat = jsonFormat2(ApiResponse)

}