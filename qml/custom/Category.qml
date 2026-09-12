/**
 * @file Category.qml
 * @brief 分类卡片容器
 *
 * 结构（自上而下）：
 *   1. 圆角渐变底板（可开阴影）；
 *   2. info 区（顶部约 8%，放副标题/状态文字）；
 *   3. content 区（主体内容，外部通过 content 别名填充子项）；
 *   4. 右下角旋转 -20° 的水印图标（backIcon，仅装饰）。
 * label 为卡片标题，显示在顶部。
 */

import QtQuick
import QtQuick.Effects
import QtQuick.Shapes

Item {
    id: categoryRoot
    property alias content: content.data
    property alias info: info.data
    property string label
    property string backIcon
    height: parent.height - parent.width * 0.02
    Shape {
        id: back
        anchors.fill: parent
        // containsMode: Shape.FillContains
        layer.enabled: Global.settings.shadow
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Global.buttonShadowColor
            shadowHorizontalOffset: shadowVerticalOffset
            shadowVerticalOffset: Global.shadowHeight
        }
        ShapePath {
            strokeWidth: 0
            PathRectangle {
                id: pathRect
                x: 0
                y: 0
                radius: back.height / 25
                width: back.width
                height: back.height
            }
            fillGradient: LinearGradient {
                y1: 0
                y2: pathRect.height
                x1: pathRect.width / 2
                x2: pathRect.width / 2
                GradientStop {
                    position: 0.13
                    color: Global.backgroundColor
                }
                GradientStop {
                    position: 0.091
                    color: Global.settings.shadow ? Qt.darker(Global.backgroundColor, 1.4) : Global.backgroundColor
                }
                GradientStop {
                    position: 0.09
                    color: Global.backgroundColor
                }
                GradientStop {
                    position: 0.0
                    color: Qt.lighter(Global.backgroundColor, 1.3)
                }
            }
        }
    }
    MyIconLabel {
        text: parent.label
        height: parent.height * 0.1
        width: parent.width
    }
    Item {
        height: parent.height * 0.5
        width: height
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        clip: true
        Icon {
            icon.source: categoryRoot.backIcon
            icon.color: Qt.darker(Global.backgroundColor, 1.03)
            anchors.right: parent.right
            anchors.rightMargin: -parent.height * 0.4
            anchors.bottom: parent.bottom
            rotation: -20
            layer.enabled: Global.settings.shadow
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Qt.lighter(Global.backgroundColor, 1.03)
                shadowVerticalOffset: Global.shadowHeight
                shadowHorizontalOffset: shadowVerticalOffset
            }
        }
    }
    Item {
        id: content
        anchors.fill: parent
        anchors.topMargin: parent.height * 0.15
        anchors.bottomMargin: parent.height * 0.04
        anchors.leftMargin: parent.height * 0.04
        anchors.rightMargin: parent.height * 0.04
    }

    Item {
        id: info
        height: parent.height * 0.08
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.01
        anchors.left: parent.left
        anchors.leftMargin: parent.height * 0.04
    }
}
