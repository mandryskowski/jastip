import MyPostgresProfile.api._
import BidJsonProtocol._
import scala.concurrent.Future
import akka.actor.ActorSystem
import java.sql.Timestamp
import java.sql.Date
import java.time.LocalDate
import scala.concurrent.ExecutionContext
import slick.lifted.{ProvenShape, TableQuery}


class AuctionRepository(db: Database)(implicit ec: ExecutionContext) {
  val auctions = TableQuery[Auctions]
  val bids = TableQuery[Bids]

  def createSchema() = {
   (auctions.schema ++ bids.schema).create
  }

  def getAll(limit: Int): Future[Seq[Auction]] = {
    db.run(auctions.take(limit).result)
  }

  def filterAuctions(params: Map[String, String], limit: Int): Future[Seq[AuctionWithPrices]] = {
    val initialQuery = auctions.take(limit)
    val filters: Seq[(String, Auctions => String => Rep[Boolean])] = Seq(
      "fragile" -> ((auction: Auctions) => (v: String) => (auction.fragile === true) || (auction.fragile === (v == "true"))),
      "startCity" -> ((auction: Auctions) => (v: String) => auction.from.toLowerCase like s"%${v.toLowerCase}%"),
      "endCity" -> ((auction: Auctions) => (v: String) => auction.to.toLowerCase like s"%${v.toLowerCase}%"),
      "endDate" -> ((auction: Auctions) => (v: String) => {
        val date = Timestamp.valueOf(LocalDate.parse(v).plusDays(1).atStartOfDay())
        auction.auctionEnd.between(Timestamp.from(date.toInstant().minusSeconds(86400 * 30)), date)
      }),
      "length" -> ((auction: Auctions) => (v: String) => auction.length >= v.toFloat),
      "width" -> ((auction: Auctions) => (v: String) => auction.width >= v.toFloat),
      "height" -> ((auction: Auctions) => (v: String) => auction.height >= v.toFloat)
    )

    val filteredQuery = filters.foldLeft(initialQuery) { case (query, (paramName, filterFunc)) =>
      params.get(paramName) match {
        case Some(value) => query.filter(filterFunc(_)(value))
        case None => query
      }
    }

    val joinedQuery = for {
      (auction, bid) <- filteredQuery joinLeft bids on (_.auctionId === _.auctionId)
    } yield (auction, bid.map(_.price))

    val auctionsWithPricesQuery = joinedQuery.result.map { result =>
      result.groupBy(_._1).map { case (auction, bids) =>
              AuctionWithPrices(
                auction.auctionId,
                auction.userId,
                auction.length,
                auction.width,
                auction.height,
                auction.fragile,
                auction.description,
                auction.from,
                auction.to,
                auction.departure,
                auction.arrival,
                auction.auctionEnd,
                auction.startingPrice,
                bids.flatMap(_._2).toList
              )
            }.toSeq
    }

    db.run(auctionsWithPricesQuery)
  }

  def insert(auction: Auction): Future[Long] = {
    db.run((auctions returning auctions.map(_.auctionId)) += auction)
  }

  def findById(auctionId: Long): Future[Option[Auction]] = {
    val query = auctions.filter(_.auctionId === auctionId).result.headOption
    db.run(query)
  }
}