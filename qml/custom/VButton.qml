/**
 * @file qml/custom/VButton.qml
 * @brief 纵向图标按钮（圆形图标在上、文字标签在下）
 *
 * 行为与 MyButton 一致：checked 绑定 Global.digital[channel]，
 * 按下发 push、抬起发 release；confirm=true 时先弹确认框再执行；
 * disableChannel 反馈为真时禁用；圆形径向渐变底板，选中下沉。
 * 调试：showChannel 打开时显示 "D+channel E+disableChannel"。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Templates as T

import "../js/crestroncip.js" as CrestronCIP

T.Button {
    id: controlVButton
    property int channel
    property int disableChannel: 0
    property bool confirm: false
    property color btnColor: Global.buttonColor
    property color btnCheckColor: Global.buttonCheckedColor

    property string source
    property color textColor: Global.buttonTextColor
    property color iconColor: checked ? Global.buttonTextCheckedColor : Global.buttonTextColor

    checked: Global.digital[controlVButton.channel] ? true : false

    enabled: Global.digital[controlVButton.disableChannel] ? false : true
    opacity: enabled ? 1 : Global.disableOpacity
    Behavior on opacity {
        OpacityAnimator {
            duration: Global.durationDelay
        }
    }
    onPressedChanged: {
        if (pressed) {
            if (!confirm) {
                CrestronCIP.push(controlVButton.channel);
            } else {
                confirmDialog.open();
            }
        } else {
            if (!confirm) {
                CrestronCIP.release(controlVButton.channel);
            }
        }
    }
    background: Shape {
        id: back
        height: controlVButton.height * 0.7
        width: height
        y: controlVButton.checked ? height / 40 : 0
        Behavior on y {
            NumberAnimation {
                duration: Global.durationDelay
            }
        }
        anchors.horizontalCenter: parent.horizontalCenter
        // containsMode: Shape.FillContains
        layer.enabled: Global.settings.shadow
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Global.buttonShadowColor
            shadowHorizontalOffset: shadowVerticalOffset
            shadowVerticalOffset: controlVButton.enabled ? (controlVButton.checked ? Global.shadowHeight / 2 : Global.shadowHeight) : Global.shadowHeight / 4
            Behavior on shadowHorizontalOffset {
                NumberAnimation {
                    duration: Global.durationDelay
                }
            }
        }
        ShapePath {
            strokeWidth: Math.ceil(controlVButton.width * 0.004)
            strokeColor: Qt.darker(controlVButton.btnColor, 1.5)
            PathRectangle {
                x: 0
                y: 0
                radius: back.width / 2
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
                property real pos: controlVButton.checked ? 1 : 0
                GradientStop {
                    position: -0.8 + gradient.pos
                    color: controlVButton.btnCheckColor
                }
                GradientStop {
                    position: 0 + gradient.pos
                    color: Qt.darker(controlVButton.btnColor, 1.5)
                }
                GradientStop {
                    position: 1 + gradient.pos
                    color: controlVButton.btnColor
                }
                Behavior on pos {
                    NumberAnimation {
                        duration: Global.durationDelay
                    }
                }
            }
        }
    }
    contentItem: MyIconLabel {
        anchors.fill: back
        icon.color: controlVButton.iconColor
        icon.source: controlVButton.source
    }
    MyIconLabel {
        id: textLabel
        width: parent.width
        height: parent.height * 0.18
        font.pixelSize: height
        anchors.bottom: parent.bottom
        color: controlVButton.textColor
        text: controlVButton.text
    }
    Text {
        id: channel
        height: parent.height
        text: Global.settings.showChannel ? "D" + controlVButton.channel + "E" + controlVButton.disableChannel : ""
        color: Global.buttonTextColor
        font.pixelSize: Global.channelSize
        font.family: Global.alibabaPuHuiTi.font.family
    }
    ConfirmDialog {
        id: confirmDialog
        dialogIcon: controlVButton.source
        dialogInfomation: "确定" + controlVButton.text + "？"
        dialogTitle: "提示"
        Timer {
            id: releaseTimer
            interval: 100
            repeat: false
            triggeredOnStart: false
            onTriggered: {
                confirmDialog.close();
                CrestronCIP.release(controlVButton.channel);
            }
        }
        onAccepted: {
            CrestronCIP.push(controlVButton.channel);
            releaseTimer.start();
        }
    }
}
