import MyPostgresProfile.api._
import BidJsonProtocol._
import scala.concurrent.duration._
import scala.concurrent.{Future, Await}
import akka.http.scaladsl.server.Directives._
import akka.actor.ActorSystem
import java.sql.Timestamp
import java.sql.Date
import java.time.LocalDate
import scala.concurrent.ExecutionContext
import slick.lifted.{ProvenShape, TableQuery}
import java.time.Instant
import java.time.temporal.ChronoUnit

class AuctionRepository(db: Database)(implicit ec: ExecutionContext) {
  val auctions = TableQuery[Auctions]
  val bids = TableQuery[Bids]

  def createSchema() = {
   (auctions.schema ++ bids.schema).create
  }

  def getAll(limit: Int): Future[Seq[Auction]] = {
    db.run(auctions.take(limit).result)
  }

  def filters(params: Map[String, String], limit: Int, query: Query[Auctions, Auction, Seq] = auctions.distinct): Query[Auctions, Auction, Seq] = {
    val initialQuery = query.take(limit)
    val filters: Seq[(String, Auctions => String => Rep[Boolean])] = Seq(
      "fragile" -> ((auction: Auctions) => (v: String) => (auction.fragile === true) || (auction.fragile === (v == "true"))),
      "startCity" -> ((auction: Auctions) => (v: String) => auction.from.toLowerCase like s"%${v.toLowerCase}%"),
      "endCity" -> ((auction: Auctions) => (v: String) => auction.to.toLowerCase like s"%${v.toLowerCase}%"),
      "endDate" -> ((auction: Auctions) => (v: String) => {
        val date = Timestamp.valueOf(v)
        auction.auctionEnd.between(Timestamp.from(date.toInstant().minusSeconds(86400 * 30)), date)
      }),
      "length" -> ((auction: Auctions) => (v: String) => auction.length >= v.toFloat),
      "width" -> ((auction: Auctions) => (v: String) => auction.width >= v.toFloat),
      "height" -> ((auction: Auctions) => (v: String) => auction.height >= v.toFloat),
      "weight" -> ((auction : Auctions) => (v: String) => auction.weight >= v.toFloat),
      "auctionId" -> ((auction: Auctions) => (v: String) => auction.auctionId === v.toLong),
      "userId" -> ((auction: Auctions) => (v: String) => auction.userId === v.toInt)
    )

    val filteredQuery = filters.foldLeft(initialQuery) { case (query, (paramName, filterFunc)) =>
      params.get(paramName) match {
        case Some(value) => query.filter(filterFunc(_)(value))
        case None => query
      }
    }

    filteredQuery
  }

  def mapAuctionToPricedAndWinnerId(auction : Auction, bids : List[Bid]) = {
      val userRepository = new UserRepository(db)
      val userInfoFuture = userRepository.getUserInfo(auction.userId)
      val reviewFuture = db.run(userRepository.reviews.filter(_.auctionId === auction.auctionId.toInt).size.result)
      val addressFuture = db.run(TableQuery[Addresses].filter(_.auctionId === auction.auctionId.toInt).result)
      val winnerInfo = bids.lastOption.map(_.userId) match {
        case Some(id) => Await.result(userRepository.getUserInfo(id), 10.seconds)
        case None     => Some(UserInfo(-1, "", "", "", 0, 0))
      }
      val userInfo = Await.result(userInfoFuture, 10.seconds)
      val hasReview = Await.result(reviewFuture, 10.seconds) != 0
      val address = Await.result(addressFuture, 10.seconds).headOption


      AuctionWithPricesAndWinnerId(
        auction.auctionId,
        userInfo.get,
        auction.length,
        auction.width,
        auction.height,
        auction.weight,
        auction.fragile,
        auction.description,
        auction.from,
        auction.to,
        auction.departure,
        auction.arrival,
        auction.auctionEnd,
        auction.startingPrice,
        bids.map(_.price),
        bids.map(_.bidId),
        winnerInfo.get,
        hasReview,
        address
      )
    }

  def mapToAuctionWithPrices(query: Query[Auctions, Auction, Seq]) = {
    val joinedQuery = for {
      (auction, bid) <- query joinLeft bids on (_.auctionId === _.auctionId)
    } yield (auction, bid)

    joinedQuery.result.map(result => result.groupBy(_._1).map {case (auction, bids) =>
        mapAuctionToPricedAndWinnerId(auction, bids.flatMap(_._2).toList)}.toSeq)
  }

  def filterAuctions(params: Map[String, String], limit: Int, query: Query[Auctions, Auction, Seq] = auctions.distinct): Future[Seq[AuctionWithPricesAndWinnerId]] = {
    val filteredQuery = filters(params, limit, query)

    db.run(mapToAuctionWithPrices(filteredQuery))
  }

  def sortAuctionsFuture(auctionsFuture: Future[Seq[AuctionWithPricesAndWinnerId]], orderedBy : Option[String]) = {
    (orderedBy match {
            case Some("date") => auctionsFuture.map(_.sortBy(_.auctionEnd).reverse)
            case Some("size") => auctionsFuture.map(_.sortBy(_.length).reverse)
            case _ => auctionsFuture.map(_.sortBy(_.auctionId).reverse)
          })
  }

  def getUserAuctions(params: Map[String, String], limit : Int): Future[Seq[AuctionWithPricesAndWinnerId]] = {
    val userId = params.get("userId").get.toInt
    val status = params.get("status")

    val currentTime = Instant.now()
    val query = auctions

    val statusQuery = status match {
      case Some("ongoing") => query.filter(_.auctionEnd > Timestamp.from(currentTime))
      case Some("inTransit") => query.filter(a => a.auctionEnd <= Timestamp.from(currentTime) && a.auctionEnd > Timestamp.from(currentTime.minus(30, ChronoUnit.DAYS)))
      case Some("completed") => query.filter(_.auctionEnd <= Timestamp.from(currentTime.minus(30, ChronoUnit.DAYS)))
      case _ => query
    }

    val filteredQuery = filters(params, limit, statusQuery)

    val joinedQuery = for {
      (auction, bid) <- filteredQuery joinLeft bids on (_.auctionId === _.auctionId)
    } yield (auction, bid)

    val finalResult = joinedQuery.result.map(as =>
      // filter passes if: user_id matches param AND (user is the winner OR queried status is ongoing or any)
      as.groupBy(_._1).filter({case (auction, bids) =>
        bids.flatMap(_._2).toList.map(_.userId).contains(userId)
      }).map {case (auction, bids) =>
        mapAuctionToPricedAndWinnerId(auction, bids.flatMap(_._2).toList) }.filter(a => a.winner.id == userId || status.getOrElse("ongoing") == "ongoing").toSeq)

    

    db.run(finalResult)
  }

  def suggestions(params: Map[String, String], limit : Int): Future[Seq[String]] = {
    val initialQuery = auctions.take(limit)

    val filters: Seq[(String, Auctions => String => Rep[Boolean])] = Seq(
      "startCity" -> ((auction: Auctions) => (v: String) => auction.from.toLowerCase like s"%${v.toLowerCase}%"),
      "endCity" -> ((auction: Auctions) => (v: String) => auction.to.toLowerCase like s"%${v.toLowerCase}%"))

    val filteredQuery = filters.foldLeft(initialQuery) { case (query, (paramName, filterFunc)) =>
      params.get(paramName) match {
        case Some(value) => query.filter(filterFunc(_)(value))
        case None => query
      }
    }

    val suggestionQuery = (params.get("column") match {
      case Some("startCity") => filteredQuery.result.map(result => result.map(_.from))
      case Some("endCity") => filteredQuery.result.map(result => result.map(_.to))
    })

    db.run(suggestionQuery.map(_.groupBy(x=>x).map(_._1).toSeq.sorted)) // remove duplicates and sort alphabetically
  }

  def verifyAuction(auction : Auction) : Option[String] = {
    if (auction.length <= 0 || auction.width <= 0 || auction.height <= 0 || auction.weight <= 0)
      Some("Dimensions and weight must be positive values")
    else if (auction.startingPrice <= 0)
      Some("Starting price must be a positive value")
    else if (!auction.departure.before(auction.arrival))
      Some("Departure must be before arrival")
    else if (!auction.auctionEnd.before(auction.departure))
      Some("Auction must end before departure")
    else if (auction.auctionEnd.before(Timestamp.from(Instant.now())))
      Some("Auction must end in the future")
    else
      None
  }
  
  def insert(auction: Auction): Future[Long] = {
    db.run((auctions returning auctions.map(_.auctionId)) += auction)
  }

  def findById(auctionId: Long): Future[Option[Auction]] = {
    val query = auctions.filter(_.auctionId === auctionId).result.headOption
    db.run(query)
  }

  def updateAuctionBids(auctionId: Long, bidId: Int) = {
    val query = auctions.filter(_.auctionId === auctionId)
    val action = query.result.head.flatMap { auction =>
      val updatedBids = auction.bids :+ bidId
      query.map(_.bids).update(updatedBids)
    }
    db.run(action.transactionally)
  }
}