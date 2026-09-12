/**
 * @file MySwitch.qml
 * @brief 开关型数字通道按钮（滑块样式）
 *
 * 状态：checked 绑定 Global.digital[channel]；
 * 交互：按下发 CrestronCIP.push(channel)、抬起发 release(channel)；
 * 视觉：胶囊轨道 + 圆形滑块（勾选时显示 ✓ 并右移），右侧可显示标签文字；
 * 调试：showChannel 打开时右侧显示 "D+channel"。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Templates as T

import "../Js/crestroncip.js" as CrestronCIP

T.Button {
    id: controlMySwitch
    property int channel

    implicitHeight: parent.height
    implicitWidth: parent.width * 2

    checked: Global.digital[controlMySwitch.channel] ? true : false

    indicator: Rectangle {
        width: height * 2
        height: parent.height * 0.5
        radius: height * 0.5
        color: controlMySwitch.checked ? Global.buttonCheckedColor : Global.buttonColor
        border.color: Global.buttonTextColor
        x: height / 2
        anchors.verticalCenter: parent.verticalCenter
        Behavior on color {
            ColorAnimation {
                duration: Global.durationDelay
            }
        }
        Rectangle {
            x: controlMySwitch.checked ? parent.width - parent.height : parent.height - height
            width: parent.height * 1.6
            height: width
            radius: height * 0.5
            color: Global.backgroundColor
            border.color: Global.buttonTextColor
            anchors.verticalCenter: parent.verticalCenter
            MyIconLabel {
                anchors.centerIn: parent
                text: "✓"
                opacity: controlMySwitch.checked ? 1 : 0
                color: Global.buttonCheckedColor
                font.pixelSize: parent.height * 0.8
                font.family: Global.alibabaPuHuiTi.font.family
                Behavior on opacity {
                    NumberAnimation {
                        duration: Global.durationDelay
                    }
                }
            }
            Behavior on x {
                NumberAnimation {
                    duration: Global.durationDelay
                }
            }
            layer.enabled: Global.settings.shadow
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Global.buttonShadowColor
                shadowHorizontalOffset: Global.shadowHeight / 2
                shadowVerticalOffset: shadowHorizontalOffset
            }
        }
    }
    contentItem: Text {
        height: parent.height
        text: controlMySwitch.text
        font.pixelSize: height * 0.7
        anchors.left: controlMySwitch.indicator.right
        leftPadding: height * 0.5
        color: Global.buttonTextColor
        font.family: Global.alibabaPuHuiTi.font.family
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: channel
        height: parent.height
        text: Global.settings.showChannel ? "D" + controlMySwitch.channel : ""
        color: Global.buttonTextColor
        font.pixelSize: Global.channelSize
        anchors.right: parent.right
        font.family: Global.alibabaPuHuiTi.font.family
    }

    onPressedChanged: {
        if (pressed) {
            //if (!checked) {
            CrestronCIP.push(controlMySwitch.channel);
        } else {
            CrestronCIP.release(controlMySwitch.channel);
            //}
        }
    }
}
