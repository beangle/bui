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

import org.beangle.template.api.ComponentContext

class Esign(context: ComponentContext) extends AbstractTextBean(context) {
  var lineWidth: String = "5"
  var height: String = "300"
  var width: String = "800"

  /** 是否允许本地图片文件 */
  var enableLocalFile: String = "true"

  /** 缺省签名的地址 */
  var remoteHref: String = _

  override def evaluateParams(): Unit = {
    super.evaluateParams()
    val f = findAncestor(classOf[Form])
    f.removeRequire(this.id)
    if (null != f) {
      f.addCheck(s"document.getElementById('${this.id}').value = esign_${this.id}.generate();")
      //move check not blank after generate
      if ("true".equals(required)) {
        f.addCheck(s"jQuery('#${this.id}').require().match('notBlank');")
      }
    }
  }
}
