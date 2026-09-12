/**
 * @file Background.qml
 * @brief 页面卡片背景底板
 *
 * 圆角矩形 + 纵向渐变（顶部 20% 处略亮、下方同色），营造立体基座效果；
 * 阴影开关（Global.settings.shadow）打开时 0.22 处插入一圈更暗的渐变带形成内凹边界。
 */

import QtQuick
import QtQuick.Shapes

Item {
    implicitHeight: parent.height
    implicitWidth: parent.width
    Shape {
        id: back
        anchors.fill: parent
        // containsMode: Shape.FillContains
        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            PathRectangle {
                id: pathRect
                x: 0
                y: 0
                radius: back.height / 20
                width: back.width
                height: back.height
            }
            fillGradient: LinearGradient {
                y1: 0
                y2: pathRect.height
                x1: pathRect.width / 2
                x2: pathRect.width / 2
                GradientStop {
                    position: 0.0
                    color: Qt.lighter(Global.backgroundColor, 1.3)
                }
                GradientStop {
                    position: 0.22
                    color: Global.backgroundColor
                }
                GradientStop {
                    position: 0.221
                    color: Global.settings.shadow ? Qt.darker(Global.backgroundColor, 1.4) : Global.backgroundColor
                }
                GradientStop {
                    position: 0.28
                    color: Global.backgroundColor
                }
            }
        }
    }
}
