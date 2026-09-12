/**
 * @file qml/dialog/ProcessDialog.qml
 * @brief 过程等待对话框（BusyIndicator 转圈提示）
 *
 * visible 绑定 Global.digital[channel]：中控把该数字反馈位置 1 时弹出，
 * 表示某操作（如投影机开关机）正在执行；关闭时自动把该反馈位清 0。
 * autoClose（默认 60s）倒计时兜底自动关闭；
 * showChannel 打开时右下角显示关联通道号 "D+channel"。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
//import QtQuick.Controls.Material

Dialog {
    id: processDialog
    property int channel
    property alias dialogTitle: title.text
    property alias dialogInfomation: info.text

    property int autoClose: 60
    property int during

    anchors.centerIn: Overlay.overlay

    implicitWidth: Overlay.overlay.width * 0.6
    implicitHeight: Overlay.overlay.height * 0.5

    closePolicy: Popup.NoAutoClose
    modal: true

    background: Background {}

    enter: Transition {
        NumberAnimation {
            from: 0
            to: 1
            property: "opacity"
            duration: Global.durationDelay
        }
    }
    exit: Transition {
        NumberAnimation {
            from: 1
            to: 0
            property: "opacity"
            duration: Global.durationDelay
        }
    }
    Column {
        anchors.fill: parent
        anchors.margins: height * 0.05
        spacing: height * 0.1
        MyIconLabel {
            id: title
            height: parent.height * 0.12
            color: Global.buttonTextColor
            text: qsTr("标题")
            font.pixelSize: height
        }
        BusyIndicator {
            id: busy
            height: parent.height * 0.55
            width: height
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: parent.height * 0.1
            //Material.accent: Global.buttonColor
            layer.enabled: Global.settings.shadow
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Global.buttonShadowColor
                shadowHorizontalOffset: Global.shadowHeight
                shadowVerticalOffset: shadowHorizontalOffset
            }
        }
        Timer {
            id: countDownTimer
            interval: 1000
            repeat: true
            triggeredOnStart: false
            onTriggered: {
                processDialog.during--
                if (processDialog.during === 0) {
                    processDialog.close()
                }
            }
        }
        MyIconLabel {
            id: info
            height: parent.height * 0.12
            width: parent.width
            color: Global.buttonTextColor
            text: qsTr("信息")
            font.pixelSize: height
        }
        Text {
            id: channel
            anchors.right: parent.right
            text: Global.settings.showChannel ? "D" + processDialog.channel : ""
            color: Global.buttonTextColor
            font.pixelSize: Global.channelSize
            font.family: Global.alibabaPuHuiTi.font.family
        }
    }
    onOpened: {
        during = autoClose
        countDownTimer.start()
    }

    onClosed: {
        let tmpD = Global.digital
        tmpD[processDialog.channel] = false
        Global.digital = tmpD
        countDownTimer.stop()
    }
    visible: Global.digital[processDialog.channel] ? true : false
}
