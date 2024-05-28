import com.typesafe.sbt.packager.archetypes.JavaAppPackaging

name := "Jastip"

version := "0.1"

scalaVersion := "2.13.8"

libraryDependencies ++= Seq(
  "com.typesafe.slick" %% "slick" % "3.3.3",
  "org.postgresql" % "postgresql" % "42.2.19",
  "com.typesafe.slick" %% "slick-hikaricp" % "3.3.3",
  "com.typesafe.akka" %% "akka-http" % "10.2.7",
  "com.typesafe.akka" %% "akka-actor" % "2.6.20",
  "com.typesafe.akka" %% "akka-stream" % "2.6.20",
  "com.zaxxer" % "HikariCP" % "3.4.5"
)

enablePlugins(JavaAppPackaging)
