// src/test/scala/AuctionRepositorySpec.scala
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import scala.concurrent.Await
import scala.concurrent.duration._
import akka.actor.ActorSystem
import java.sql.Timestamp
import MyPostgresProfile.api._

// Assuming you have an AuctionRepository class
class AuctionRepositorySpec extends AnyFlatSpec with Matchers {
  // Define a test database
  val db = Database.forConfig("testDatabase")

  // Create a new instance of your repository
  val auctionRepo = new AuctionRepository(db)(ActorSystem("my-system").dispatcher)

  "AuctionRepository" should "insert and retrieve an auction" in {
    // Set up the database schema
    Await.result(db.run(auctionRepo.createSchema()), 2.seconds)

    // Insert a test auction 
    val testAuction = Auction(1L, 1, 10.0f, 10.0f, 10.0f, false, "Test Auction", "City A", "City B", Timestamp.valueOf("2022-01-01 00:00:00"), Timestamp.valueOf("2022-01-02 00:00:00"), Timestamp.valueOf("2022-01-03 00:00:00"), 100.0, List())
    Await.result(auctionRepo.insert(testAuction), 2.seconds)

    // Retrieve the auction
    val retrievedAuction = Await.result(auctionRepo.findById(1L), 2.seconds)

    // Verify the auction
    retrievedAuction shouldEqual Some(testAuction)
  }
}
