import org.beangle.parent.Dependencies.*
import org.beangle.parent.Settings.*

ThisBuild / organization := "org.beangle.bui"
ThisBuild / version := "0.0.2"

ThisBuild / scmInfo := Some(
  ScmInfo(
    url("https://github.com/beangle/bui"),
    "scm:git@github.com:beangle/bui.git"
  )
)

ThisBuild / developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = url("http://github.com/duantihua")
  )
)

ThisBuild / description := "The Beangle BUI Library"
ThisBuild / homepage := Some(url("https://beangle.github.io/bui/index.html"))

val beangle_webmvc = "org.beangle.webmvc" % "beangle-webmvc" % "0.10.3"
val beangle_template = "org.beangle.template" % "beangle-template" % "0.1.23"

lazy val root = (project in file("."))
  .settings()
  .aggregate(tag, bootstrap)

lazy val tag = (project in file("tag"))
  .settings(
    name := "beangle-bui-tag",
    common,
    libraryDependencies ++= Seq(logback_classic % "test", scalatest),
    libraryDependencies ++= Seq(beangle_webmvc, beangle_template),
  )

lazy val bootstrap = (project in file("bootstrap"))
  .settings(
    name := "beangle-bui-bootstrap",
    common
  ).dependsOn(tag)

lazy val asset = (project in file("static"))
  .settings(
    name := "beangle-bui-static",
    version := "0.6.4",
    common
  )

publish / skip := true
