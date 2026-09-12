/**
 * @file qml/custom/InputButton.qml
 * @brief 可拖拽的输入源按钮（信号切换场景）
 *
 * 结构：半透明底卡（back2，作为放置时的视觉参照）+ 可拖动前卡（back）；
 * 交互：MouseArea 拖动 back，Drag.keys 携带 [input 编号, 按钮颜色]，
 *       松手 back.Drag.drop() 后立即归位；Output 组件的 DropArea
 *       接收后调用 CrestronCIP.level(output, input) 完成信号切换。
 * input：输入源编号（Drag 携带键）；textInput/iconSource：卡片文字与图标；
 * disableOutput：禁用通道（备用）；右上角淡显 input 编号。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Shapes

Item {
    id: controlInputButton
    property int input
    property color btnColor: Global.buttonCheckedColor
    property color btnTextColor: Global.buttonTextColor
    property string textInput
    property string iconSource
    property int disableOutput

    // property real dragX
    // property real dragY

    width: parent.width
    height: parent.height
    z: back.y != 0 || back.x != 0 ? 1 : 0

    signal pressedChanged(bool pressed)
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: back
        onPressedChanged: {
            if (pressed) {
                controlInputButton.pressedChanged(true);
                back.Drag.hotSpot.x = 0;
                back.Drag.hotSpot.y = back.height / 2;
            } else {
                back.Drag.drop();
                back.y = 0;
                back.x = 0;
                controlInputButton.pressedChanged(false);
            }
        }
    }

    Shape {
        id: back2
        width: parent.width
        height: parent.height
        opacity: 0.5
        ShapePath {
            strokeWidth: Math.ceil(controlInputButton.width * 0.004)
            strokeColor: Qt.darker(controlInputButton.btnColor, 1.5)
            PathRectangle {
                x: 0
                y: 0
                width: back2.width
                height: back2.height
                radius: height / 5
            }
            fillGradient: RadialGradient {
                centerX: back2.width * 0.5
                centerY: back2.height * 0.5
                centerRadius: Math.max(back2.width, back2.height)
                focalX: back2.width * 0.5
                focalY: back2.height
                GradientStop {
                    position: 1
                    color: controlInputButton.btnColor
                }
            }
        }
        MyIconLabel {
            font.pixelSize: height * 0.25
            height: parent.height
            width: parent.width
            text: controlInputButton.textInput
            icon.source: controlInputButton.iconSource
        }
        layer.enabled: Global.settings.shadow
        layer.effect: MultiEffect {
            id: effect2
            shadowEnabled: true
            shadowColor: Global.buttonShadowColor
            shadowHorizontalOffset: shadowVerticalOffset / 2
            shadowVerticalOffset: mouseArea.pressed ? Global.shadowHeight / 2 : Global.shadowHeight
            Behavior on shadowHorizontalOffset {
                NumberAnimation {
                    duration: Global.durationDelay
                }
            }
        }
        Text {
            width: parent.width
            height: parent.height
            text: controlInputButton.input
            font.pixelSize: height
            color: controlInputButton.btnTextColor
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
            font.bold: true
            opacity: 0.1
            font.family: Global.alibabaPuHuiTi.font.family
        }
    }

    Shape {
        id: back
        Behavior on x {
            NumberAnimation {
                duration: Global.durationDelay
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: Global.durationDelay
            }
        }

        width: parent.width
        height: parent.height
        ShapePath {
            strokeWidth: Math.ceil(controlInputButton.width * 0.004)
            strokeColor: Qt.darker(controlInputButton.btnColor, 1.5)
            PathRectangle {
                x: 0
                y: 0
                width: back.width
                height: back.height
                radius: height / 5
            }
            fillGradient: RadialGradient {
                centerX: back.width * 0.5
                centerY: back.height * 0.5
                centerRadius: Math.max(back.width, back.height)
                focalX: back.width * 0.5
                focalY: back.height
                GradientStop {
                    position: mouseArea.pressed ? 0 : 1
                    color: controlInputButton.btnColor
                    Behavior on color {
                        ColorAnimation {
                            duration: Global.durationDelay
                        }
                    }
                }
                GradientStop {
                    position: mouseArea.pressed ? 1 : 0
                    color: Qt.darker(controlInputButton.btnColor, 1.5)
                    Behavior on color {
                        ColorAnimation {
                            duration: Global.durationDelay
                        }
                    }
                }
            }
        }
        MyIconLabel {
            font.pixelSize: height * 0.25
            height: parent.height
            width: parent.width
            text: controlInputButton.textInput
            icon.source: controlInputButton.iconSource
        }
        layer.enabled: Global.settings.shadow
        layer.effect: MultiEffect {
            id: effect
            shadowEnabled: true
            shadowColor: Global.buttonShadowColor
            shadowHorizontalOffset: shadowVerticalOffset / 2
            shadowVerticalOffset: mouseArea.pressed ? Global.shadowHeight / 2 : Global.shadowHeight
            Behavior on shadowHorizontalOffset {
                NumberAnimation {
                    duration: Global.durationDelay
                }
            }
        }
        Text {
            width: parent.width
            height: parent.height
            text: controlInputButton.input
            font.pixelSize: height
            color: controlInputButton.btnTextColor
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
            font.bold: true
            opacity: 0.1
            font.family: Global.alibabaPuHuiTi.font.family
        }
        clip: true
        Drag.keys: [controlInputButton.input, controlInputButton.btnColor]
        Drag.active: mouseArea.drag.active
    }
}
