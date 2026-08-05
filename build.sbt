import org.beangle.parent.Dependencies.*
import org.beangle.parent.Settings.*

organization := "org.beangle.bui"
version := "0.8.7-SNAPSHOT"

scmInfo := Some(
  ScmInfo(
    uri("https://github.com/beangle/bui"),
    "scm:git@github.com:beangle/bui.git"
  )
)

developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = uri("http://github.com/duantihua")
  )
)

description := "The Beangle BUI Library"
homepage := Some(uri("https://beangle.github.io/bui/index.html"))
resolvers += Resolver.mavenLocal

val beangle_webmvc = "org.beangle.webmvc" % "beangle-webmvc" % "0.15.0"
val beangle_template = "org.beangle.template" % "beangle-template" % "0.2.8"

lazy val root = (project in file("."))
  .settings(
    name := "beangle-bui",
    common,
    publish / skip := true
  ).aggregate(tag, bootstrap, static)

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

lazy val static = (project in file("static"))
  .settings(
    name := "beangle-bui-static",
    common
  )
