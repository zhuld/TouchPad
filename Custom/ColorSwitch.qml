/**
 * @file ColorSwitch.qml
 * @brief 胶囊式开关（基于 T.Switch，用于标题栏深浅主题切换）
 *
 * 滑块式指示器：勾选时轨道变色、滑块右移并渐显 ✓；
 * 所有颜色/位移变化均带 durationDelay 动画；滑块带阴影。
 */

import QtQuick
import QtQuick.Effects
import QtQuick.Templates as T

T.Switch {
    id: controlColorSwitch
    implicitHeight: parent.height
    implicitWidth: parent.width

    indicator: Rectangle {
        id: indicator
        width: height * 2
        height: parent.height * 0.5
        radius: height * 0.5
        color: controlColorSwitch.checked ? Global.buttonCheckedColor : Global.backgroundColor
        border.color: Global.buttonTextColor
        x: height / 2
        anchors.verticalCenter: parent.verticalCenter
        Behavior on color {
            ColorAnimation {
                duration: Global.durationDelay
            }
        }
        Rectangle {
            x: controlColorSwitch.checked ? parent.width - parent.height : parent.height - height
            width: parent.height * 1.6
            height: width
            radius: height * 0.5
            color: Global.backgroundColor
            border.color: Global.buttonTextColor
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color {
                ColorAnimation {
                    duration: Global.durationDelay
                }
            }
            MyIconLabel {
                anchors.centerIn: parent
                text: "✓"
                opacity: controlColorSwitch.checked ? 1 : 0
                color: Global.buttonCheckedColor
                font.pixelSize: parent.height * 0.8
                font.family: Global.alibabaPuHuiTi.font.family
                Behavior on opacity {
                    NumberAnimation {
                        duration: Global.durationDelay
                    }
                }
            }
            layer.enabled: Global.settings.shadow
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Global.buttonShadowColor
                shadowHorizontalOffset: Global.shadowHeight / 2
                shadowVerticalOffset: shadowHorizontalOffset
            }
            Behavior on x {
                NumberAnimation {
                    duration: Global.durationDelay
                }
            }
        }
    }
    contentItem: Text {
        height: parent.height
        text: controlColorSwitch.text
        font.pixelSize: height * 0.7
        anchors.left: indicator.right
        leftPadding: height
        color: Global.buttonTextColor
        font.family: Global.alibabaPuHuiTi.font.family
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
}
