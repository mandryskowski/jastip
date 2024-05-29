import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport._
import spray.json.DefaultJsonProtocol._
import Bid._
import MyJsonProtocol._


object BidJsonProtocol extends spray.json.DefaultJsonProtocol {
  implicit val bidFormat = jsonFormat5(Bid)
}