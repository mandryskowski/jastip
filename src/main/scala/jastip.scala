import slick.jdbc.PostgresProfile.api._

import scala.concurrent.Await
import scala.concurrent.duration._

object DatabasePing extends App {

  // Define your database configuration
  val db = Database.forConfig("mydb") // Assumes "mydb" section is defined in application.conf

  // Define a simple query to ping the database
  val pingQuery = sql"SELECT 1".as[Int]

  // Execute the query and handle the result
  val resultFuture = db.run(pingQuery)

  // Wait for the result and print it
  val result = Await.result(resultFuture, 5.seconds)
  println("Ping result: " + result.head)

  // Close the database connection
  db.close()
}
