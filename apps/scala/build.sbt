ThisBuild / scalaVersion := "3.3.4"
ThisBuild / organization := "algorithm"
ThisBuild / version      := "1.0.0"

lazy val root = (project in file("."))
  .settings(
    name := "algorithm",
    libraryDependencies ++= Seq(
      "org.scalatest" %% "scalatest" % "3.2.18" % Test
    ),
    testOptions += Tests.Argument(TestFrameworks.ScalaTest, "-v"),
    Test / fork := false
  )
