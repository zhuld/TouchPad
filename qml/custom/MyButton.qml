/**
 * @file qml/custom/MyButton.qml
 * @brief 最常用的数字(D)通道按钮（基于 T.Button）
 *
 * 状态：checked 绑定 Global.digital[channel]，由中控反馈驱动；
 * 交互：按下发 CrestronCIP.push(channel)、抬起发 release(channel)；
 *       confirm=true 时改为先弹确认框（ConfirmDialog）再 push，100ms 后自动 release；
 * 联动：disableChannel 对应数字反馈为真时按钮禁用（半透明）；
 * 视觉：径向渐变圆角底板，选中时下沉浸入感 + 阴影变浅；
 * 调试：showChannel 打开时左上角显示 "D+channel E+disableChannel"。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Templates as T

import "../js/crestroncip.js" as CrestronCIP
import "../dialog"

T.Button {
    id: controlMyButton
    property int channel
    property int disableChannel: 0
    property bool confirm: false
    property color btnColor: Global.buttonColor
    property color btnCheckColor: Global.buttonCheckedColor

    property real radius: controlMyButton.height / 5
    property string source
    property color textColor: checked ? Global.buttonTextCheckedColor : Global.buttonTextColor
    property color iconColor: checked ? Global.buttonTextCheckedColor : Global.buttonTextColor

    checked: Global.digital[controlMyButton.channel] ? true : false

    implicitHeight: parent.height
    implicitWidth: parent.width

    enabled: Global.digital[controlMyButton.disableChannel] ? false : true
    opacity: enabled ? 1 : Global.disableOpacity
    Behavior on opacity {
        OpacityAnimator {
            duration: Global.durationDelay
        }
    }

    onPressedChanged: {
        if (pressed) {
            if (!confirm) {
                CrestronCIP.push(controlMyButton.channel);
            } else {
                confirmDialog.open();
            }
        } else {
            if (!confirm) {
                CrestronCIP.release(controlMyButton.channel);
            }
        }
    }
    contentItem: MyIconLabel {
        anchors.fill: back
        color: controlMyButton.textColor
        icon.color: controlMyButton.iconColor
        icon.source: controlMyButton.source
        text: controlMyButton.text
    }
    background: Shape {
        id: back
        height: parent.height
        width: parent.width
        y: controlMyButton.checked ? height / 40 : 0
        Behavior on y {
            NumberAnimation {
                duration: Global.durationDelay
            }
        }
        // containsMode: Shape.FillContains
        layer.enabled: Global.settings.shadow
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Global.buttonShadowColor
            shadowHorizontalOffset: shadowVerticalOffset
            shadowVerticalOffset: controlMyButton.enabled ? (controlMyButton.checked ? Global.shadowHeight / 2 : Global.shadowHeight) : Global.shadowHeight / 4
            Behavior on shadowHorizontalOffset {
                NumberAnimation {
                    duration: Global.durationDelay
                }
            }
        }
        ShapePath {
            strokeWidth: Math.ceil(controlMyButton.width * 0.004)
            strokeColor: Qt.darker(controlMyButton.btnColor, 1.5)
            PathRectangle {
                id: pathRect
                x: 0
                y: 0
                radius: controlMyButton.radius
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
                property real pos: controlMyButton.checked ? 1 : 0
                GradientStop {
                    position: -0.8 + gradient.pos
                    color: controlMyButton.btnCheckColor
                }
                GradientStop {
                    position: 0 + gradient.pos
                    color: Qt.darker(controlMyButton.btnColor, 1.5)
                }
                GradientStop {
                    position: 1 + gradient.pos
                    color: controlMyButton.btnColor
                }

                Behavior on pos {
                    NumberAnimation {
                        duration: Global.durationDelay
                    }
                }
            }
        }
    }
    ConfirmDialog {
        id: confirmDialog
        dialogIcon: controlMyButton.source
        dialogInfomation: "确定" + controlMyButton.text + "？"
        dialogTitle: "提示"
        Timer {
            id: releaseTimer
            interval: 100
            repeat: false
            triggeredOnStart: false
            onTriggered: {
                confirmDialog.close();
                CrestronCIP.release(controlMyButton.channel);
            }
        }
        onAccepted: {
            CrestronCIP.push(controlMyButton.channel);
            releaseTimer.start();
        }
    }
    Text {
        id: channel
        height: parent.height
        text: Global.settings.showChannel ? "D" + controlMyButton.channel + "E" + controlMyButton.disableChannel : ""
        color: Global.buttonTextColor
        font.pixelSize: Global.channelSize
        font.family: Global.alibabaPuHuiTi.font.family
    }
}
