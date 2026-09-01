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

package org.beangle.bui.aot

import org.beangle.bui.*
import org.beangle.commons.aot.AotPolicy
import org.beangle.commons.bean.meta.MetaRegistrar
import org.beangle.webmvc.asset.Static

/** bui tag 库的 GraalVM native-image 反射提示。
 *
 * - `BeangleTagLibrary`：bind("mvc.TagLibrary.b") 的实例化目标。
 * - tag 组件类：DefaultTagTemplateEngine 运行期经 getConstructor(ComponentContext)
 *   反射实例化，BeanInfos/MetaLoader 经 declared 方法与字段 dig 属性。
 */
class BuiMetaRegistrar extends MetaRegistrar {

  private val componentPolicy = AotPolicy(Set(
    AotPolicy.Category.PublicConstructors,
    AotPolicy.Category.DeclaredMethods,
    AotPolicy.Category.DeclaredFields))

  override def registering(): Unit = {
    register(classOf[BeangleModels], classOf[Rest], classOf[Static])
    hints.registerType(classOf[BeangleTagLibrary], componentPolicy)

    register(
      classOf[AbstractTextBean],
      classOf[ActionClosingUIBean],
      classOf[ActionIterableUIBean],
      classOf[ActionUIBean],
      classOf[Anchor],
      classOf[Card],
      classOf[CardBody],
      classOf[CardFooter],
      classOf[CardHeader],
      classOf[CardTools],
      classOf[Cellphone],
      classOf[Checkbox],
      classOf[Checkboxes],
      classOf[Combobox],
      classOf[Date],
      classOf[Dialog],
      classOf[Div],
      classOf[Editor],
      classOf[Email],
      classOf[Esign],
      classOf[Field],
      classOf[Fieldset],
      classOf[File],
      classOf[Foot],
      classOf[Form],
      classOf[Formfoot],
      classOf[Grid],
      classOf[HairLine],
      classOf[Head],
      classOf[Iframe],
      classOf[Messages],
      classOf[Nav],
      classOf[Navbar],
      classOf[Navitem],
      classOf[Number],
      classOf[Pagebar],
      classOf[Password],
      classOf[Radio],
      classOf[Radios],
      classOf[Range],
      classOf[Reset],
      classOf[Select],
      classOf[Select2],
      classOf[Startend],
      classOf[Submit],
      classOf[Tab],
      classOf[Tabs],
      classOf[Textarea],
      classOf[Textfield],
      classOf[Textfields],
      classOf[Time],
      classOf[Toolbar],
      classOf[Url],
      classOf[Validity])

    register(
      classOf[Grid.Bar],
      classOf[Grid.Boxcol],
      classOf[Grid.Col],
      classOf[Grid.Filter],
      classOf[Grid.Row],
      classOf[Grid.Treecol])

    register(
      classOf[Anchor.type],
      classOf[Date.type],
      classOf[Grid.type],
      classOf[MathOps.type])

    register(classOf[WebUIBean])
  }
}
