import java.sql.Timestamp
import java.text.SimpleDateFormat
import spray.json._

object MyJsonProtocol {
    implicit object TimestampFormat extends JsonFormat[Timestamp] {
    def write(obj: Timestamp): JsValue = JsString(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(obj.getTime))

    def read(json: JsValue): Timestamp = json match {
        case JsString(s) => new Timestamp(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(s).getTime)
        case _ => throw DeserializationException("Timestamp string expected")
    }
    }
}