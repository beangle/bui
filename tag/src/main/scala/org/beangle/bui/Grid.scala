/*
 * Copyright (C) 2005, The Beangle Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.beangle.bui

import org.beangle.commons.collection.page.Page
import org.beangle.commons.lang.{Objects, Strings}
import org.beangle.commons.text.escape.XmlEscaper
import org.beangle.template.api.{ClosingUIBean, ComponentContext, IterableUIBean, Themes}
import org.beangle.webmvc.context.ActionContext

import java.io.Writer
import java.util as ju
import scala.jdk.javaapi.CollectionConverters.asScala

object Grid {

  class Filter(context: ComponentContext) extends ClosingUIBean(context) {
    var property: String = _

    override def doEnd(writer: Writer, body: String): Boolean = {
      val grid = findAncestor(classOf[Grid])
      if (null != property && null != grid) {
        grid.filters.put(property, body)
      }
      false
    }
  }

  class Bar(context: ComponentContext) extends ClosingUIBean(context) {
    val grid: Grid = findAncestor(classOf[Grid])

    override def doEnd(writer: Writer, body: String): Boolean = {
      grid.bar = body
      false
    }
  }

  class Row(context: ComponentContext) extends IterableUIBean(context) {
    val table: Grid = findAncestor(classOf[Grid])
    val var_index: String = table.`var` + "_index"
    var index: Int = -1
    var curObj: Any = _
    var innerTr: Option[Boolean] = None

    private val iterator: Iterator[Any] = {
      table.items match {
        case iterbl: Iterable[_] => if (iterbl.iterator.hasNext) iterbl.iterator else List(null).iterator
        case javaIter: ju.Collection[_] => asScala(javaIter.iterator())
      }
    }

    def hasTr: Boolean = {
      innerTr.getOrElse({
        var i = 0
        var innerTr = false
        var doWhile = true
        // max try count is 10
        while (doWhile && i < body.length() && i < 10) {
          if (body.charAt(i) == '<' && Strings.substring(body, i, i + 3).equals("<tr")) {
            innerTr = true
            doWhile = false
          }
          i = i + 1
        }
        this.innerTr = Some(innerTr)
        innerTr
      })
    }

    override protected def next(): Boolean = {
      val ctx = ActionContext.current
      if (iterator != null && iterator.hasNext) {
        index = index + 1
        curObj = iterator.next()
        ctx.attribute(table.`var`, curObj)
        ctx.attribute(var_index, index.asInstanceOf[Object])
        return true
      } else {
        ctx.removeAttribute(table.`var`, var_index)
      }
      false
    }
  }

  class Col(context: ComponentContext) extends ClosingUIBean(context) {
    var property: String = _
    var _title: String = _
    var width: String = _
    var row: Row = _
    var sortable: String = _
    var filterable: String = _
    var escape: String = _

    override def start(writer: Writer): Boolean = {
      row = findAncestor(classOf[Row])
      if (row.index == 0) row.table.addCol(this)
      null != row.curObj
    }

    override def doEnd(writer: Writer, body: String): Boolean = {
      if (context.theme == Themes.Default) {
        try {
          writer.append("<td").append(parameterString).append(">")
          if (Strings.isNotEmpty(body)) {
            writer.append(body)
          } else if (null != property) {
            writer.append(if (escape == "true") XmlEscaper.escape(this.value) else this.value)
          }
          writer.append("</td>")
        } catch {
          case e: Throwable => e.printStackTrace()
        }
        false
      } else {
        super.doEnd(writer, body)
      }
    }

    /**
     * find value of row.obj's property
     */
    def value: String = {
      getValue(row.curObj, property) match {
        case null => ""
        case s: String => s
        case Some(d) => if (null == d) "" else d.toString
        case None => ""
        case a: Iterable[_] => if (a.isEmpty) "" else a.toString
        case any: Any => any.toString
      }
    }

    def title_=(title: String): Unit = {
      this._title = title
    }

    def propertyPath: String = {
      Strings.concat(row.table.`var`, ".", property)
    }

    /**
     * 支持按照属性提取国际化英文名
     */
    def title: String = {
      if (null == _title) {
        _title = Strings.concat(row.table.`var`, ".", property)
      }
      getText(_title)
    }

    def curObj: Any = row.curObj

  }

  class Treecol(context: ComponentContext) extends Col(context) {
    override def doEnd(writer: Writer, body: String): Boolean = {
      this.body = body
      mergeTemplate(writer)
      false
    }

  }

  class Boxcol(context: ComponentContext) extends Col(context) {

    var `type` = "checkbox"

    // checkbox or radiobox name
    var boxname: String = _

    /** display or none */
    var display: Boolean = true

    var checked: Boolean = _

    override def start(writer: Writer): Boolean = {
      if (null == property) this.property = "id"
      row = findAncestor(classOf[Row])
      if (null == boxname) boxname = row.table.`var` + "." + property
      if (row.index == 0) row.table.addCol(this)
      null != row.curObj
    }

    override def doEnd(writer: Writer, body: String): Boolean = {
      if (context.theme == Themes.Default) {
        try {
          writer.append("<td class=\"grid-select\"")
          if (null != id) writer.append(" id=\"").append(id).append("\"")
          writer.append(parameterString).append(">")
          if (display) {
            writer.append("<input class=\"box\" name=\"").append(boxname).append("\" value=\"")
              .append(String.valueOf(this.value)).append("\" type=\"").append(`type`).append("\"")
            if (checked) writer.append(" checked=\"checked\"")
            writer.append("/>")
          }
          if (Strings.isNotEmpty(body)) writer.append(body)
          writer.append("</td>")
        } catch {
          case e: Exception => e.printStackTrace()
        }
        false
      } else {
        super.doEnd(writer, body)
      }
    }

    override def title: String = {
      Strings.concat(row.table.`var`, "_", property)
    }
  }

}

class Grid(context: ComponentContext) extends ClosingUIBean(context) {

  import Grid.*

  val cols = new collection.mutable.ListBuffer[Col]
  val colTitles = new collection.mutable.HashSet[Object]
  var items: Object = _
  var caption: String = _
  var `var`: String = _
  var bar: String = _
  var sortable = "true"
  var filterable = "false"
  var filters = new collection.mutable.HashMap[String, String]

  /** 重新载入的时间间隔（以秒为单位） */
  var refresh: String = _

  /** 没有数据时显示的文本 */
  var emptyMsg: String = _

  def hasbar: Boolean = {
    null != bar || items.isInstanceOf[Page[_]]
  }

  def pageable: Boolean = {
    items.isInstanceOf[Page[_]]
  }

  def notFullPage: Boolean = {
    items match {
      case p: Page[_] => p.size < p.pageSize
      case c: ju.Collection[_] => c.isEmpty
      case s: collection.Seq[_] => s.isEmpty
    }
  }

  def defaultSort(property: String): String = Strings.concat(`var`, ".", property)

  def isSortable(cln: Col): Boolean = {
    val sortby = cln.parameters.get("sort").orNull
    if (null != sortby) true
    else "true".equals(sortable) && !Objects.equals(cln.sortable, "false") && null != cln.property
  }

  def isFilterable(cln: Col): Boolean = {
    "true".equals(filterable) && !Objects.equals(cln.filterable, "false") && null != cln.property
  }

  def addCol(column: Col): Unit = {
    var title = column.title
    if (null == title) title = column.property
    if (null == column.width && column.isInstanceOf[Boxcol]) column.width = "32px"
    if (!colTitles.contains(title)) {
      colTitles.add(title)
      cols += column
    }
  }

  override def evaluateParams(): Unit = {
    generateIdIfEmpty()
  }
}
