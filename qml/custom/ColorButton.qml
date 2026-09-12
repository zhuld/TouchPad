/**
 * @file qml/custom/ColorButton.qml
 * @brief 通用颜色按钮（基于 T.Button）
 *
 * 视觉：径向渐变圆角底板 + 深色描边 + 阴影；
 * 交互：按下时整体下沉（y 位移）且阴影变浅，渐变色标随 pos 位移形成按压高光；
 * 可通过 btnColor/btnCheckColor/textColor/iconColor/source 定制配色与图标，
 * btnColor 为 transparent 时自动关闭阴影（如标题栏的透明图标按钮）。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Templates as T

T.Button {
    id: controlColorButton
    property color btnColor: Global.buttonColor
    property color btnCheckColor: Global.buttonCheckedColor
    property color textColor: Global.buttonTextColor
    property color iconColor: Global.buttonTextColor
    property string source

    property real radius: height / 5

    implicitHeight: parent.height
    implicitWidth: parent.width

    opacity: enabled ? 1 : Global.disableOpacity

    contentItem: MyIconLabel {
        anchors.fill: back
        icon.source: controlColorButton.source
        icon.color: controlColorButton.iconColor
        color: controlColorButton.textColor
        text: controlColorButton.text
    }
    background: Shape {
        id: back
        height: parent.height
        width: parent.width
        y: controlColorButton.pressed ? height / 40 : 0
        anchors.horizontalCenter: parent.horizontalCenter
        Behavior on y {
            NumberAnimation {
                duration: Global.durationDelay
            }
        }
        layer.enabled: Global.settings.shadow
        layer.effect: MultiEffect {
            shadowEnabled: !Qt.colorEqual(controlColorButton.btnColor, "transparent")
            shadowColor: Global.buttonShadowColor
            shadowHorizontalOffset: shadowVerticalOffset
            shadowVerticalOffset: controlColorButton.pressed ? Global.shadowHeight / 4 : Global.shadowHeight / 2
            Behavior on shadowHorizontalOffset {
                NumberAnimation {
                    duration: Global.durationDelay
                }
            }
        }
        ShapePath {
            strokeWidth: Math.ceil(controlColorButton.width * 0.004)
            strokeColor: Qt.darker(controlColorButton.btnColor, 1.5)
            PathRectangle {
                id: pathRect
                x: 0
                y: 0
                radius: controlColorButton.radius
                width: back.width
                height: back.height
            }
            fillGradient: RadialGradient {
                id: gradient
                centerX: back.width * 0.5
                centerY: back.height * 0.5
                focalX: back.width * 0.5
                focalY: back.height
                centerRadius: Math.max(back.width, back.height)
                property real pos: controlColorButton.pressed ? 1 : 0
                GradientStop {
                    position: -0.8 + gradient.pos
                    color: controlColorButton.btnCheckColor
                }
                GradientStop {
                    position: 0 + gradient.pos
                    color: Qt.darker(controlColorButton.btnColor, 1.5)
                }
                GradientStop {
                    position: 1 + gradient.pos
                    color: controlColorButton.btnColor
                }

                Behavior on pos {
                    NumberAnimation {
                        duration: Global.durationDelay
                    }
                }
            }
        }
    }
}
