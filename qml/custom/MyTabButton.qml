/**
 * @file qml/custom/MyTabButton.qml
 * @brief 标签页按钮（基于 T.TabButton，图标在上、文字在下）
 *
 * 状态：checked 绑定 Global.digital[channel]（选中态由中控反馈驱动）；
 * 交互：按下发 CrestronCIP.push(channel)、抬起发 release(channel)；
 * 联动：disableChannel 反馈为真时禁用；
 * 调试：showChannel 打开时显示 "D+channel E+disableChannel"。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Templates as T

import "../js/crestroncip.js" as CrestronCIP

T.TabButton {
    id: controlMyTabButton
    property int channel
    property int disableChannel: 0
    property color btnColor: Global.backgroundColor
    property color btnCheckColor: Global.buttonCheckedColor

    property string source
    property color textColor: checked ? Global.buttonTextCheckedColor : Global.buttonTextColor
    property color iconColor: checked ? Global.buttonTextCheckedColor : Global.buttonTextColor
    checked: Global.digital[controlMyTabButton.channel] ? true : false

    enabled: Global.digital[controlMyTabButton.disableChannel] ? false : true
    opacity: enabled ? 1 : Global.disableOpacity

    onPressedChanged: {
        if (pressed) {
            CrestronCIP.push(controlMyTabButton.channel);
        } else {
            CrestronCIP.release(controlMyTabButton.channel);
        }
    }
    contentItem: MyIconLabel {
        font.pixelSize: height * 0.2
        anchors.fill: back
        spacing: height * 0.01
        display: AbstractButton.TextUnderIcon
        color: controlMyTabButton.textColor
        icon.color: controlMyTabButton.iconColor
        icon.source: controlMyTabButton.source
        text: controlMyTabButton.text
    }

    background: Shape {
        id: back
        height: controlMyTabButton.height
        width: controlMyTabButton.width
        y: controlMyTabButton.checked ? height / 40 : 0
        Behavior on y {
            NumberAnimation {
                duration: Global.durationDelay
            }
        }
        layer.enabled: Global.settings.shadow
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Global.buttonShadowColor
            shadowHorizontalOffset: shadowVerticalOffset
            shadowVerticalOffset: controlMyTabButton.enabled ? (controlMyTabButton.checked ? Global.shadowHeight / 2 : Global.shadowHeight) : Global.shadowHeight / 4
            Behavior on shadowHorizontalOffset {
                NumberAnimation {
                    duration: Global.durationDelay
                }
            }
        }
        ShapePath {
            strokeWidth: Math.ceil(controlMyTabButton.width * 0.004)
            strokeColor: Qt.darker(controlMyTabButton.btnColor, 1.5)
            PathRectangle {
                x: 0
                y: 0
                radius: back.width / 5
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
                property real pos: controlMyTabButton.checked ? 1 : 0
                GradientStop {
                    position: -0.8 + gradient.pos
                    color: controlMyTabButton.btnCheckColor
                }
                GradientStop {
                    position: 0 + gradient.pos
                    color: Qt.darker(controlMyTabButton.btnColor, 1.5)
                }
                GradientStop {
                    position: 1 + gradient.pos
                    color: controlMyTabButton.btnColor
                }

                Behavior on pos {
                    NumberAnimation {
                        duration: Global.durationDelay
                    }
                }
            }
        }
    }

    Text {
        id: channel
        height: controlMyTabButton.height
        text: Global.settings.showChannel ? "D" + controlMyTabButton.channel + "E" + controlMyTabButton.disableChannel : ""
        color: Global.buttonTextColor
        font.pixelSize: Global.channelSize
        font.family: Global.alibabaPuHuiTi.font.family
    }
}
