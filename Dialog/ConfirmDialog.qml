/**
 * @file ConfirmDialog.qml
 * @brief 通用确认对话框（危险操作二次确认）
 *
 * 用法：dialogTitle/dialogInfomation/dialogIcon 定制文案与图标，
 *       onAccepted 处理确认逻辑；
 * 弹出时启动 autoClose（默认 30s）倒计时，超时自动关闭，防止无人值守时弹窗滞留；
 * 模态、不点击外部关闭，进出带 durationDelay 淡入淡出。
 */

import QtQuick
import QtQuick.Controls

import "../"

Dialog {
    id: confirmDialog
    property alias dialogTitle: title.text
    property alias dialogInfomation: info.text
    property alias dialogIcon: info.icon.source
    //signal confirmed

    property int autoClose: 30
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
        spacing: height * 0.15
        MyIconLabel {
            id: title
            height: parent.height * 0.12
            color: Global.buttonTextColor
            text: qsTr("标题")
            font.pixelSize: height
        }
        MyIconLabel {
            id: info
            height: parent.height * 0.35
            width: parent.width
            color: Global.buttonTextColor
            icon.color: Global.buttonTextColor
        }
        Row {
            width: parent.width
            height: parent.height * 0.24
            spacing: width * 0.06
            layoutDirection: Qt.RightToLeft
            ColorButton {
                id: settingOK
                width: parent.width * 0.4
                height: parent.height
                text: "确定"
                onClicked: confirmDialog.accept()
                btnColor: Global.buttonColor
            }
            ColorButton {
                id: settingCancel
                width: parent.width * 0.4
                height: parent.height
                text: "取消"
                onClicked: confirmDialog.reject()
            }
        }
    }
    Timer {
        id: countDownTimer
        interval: 1000
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            confirmDialog.during--;
            if (confirmDialog.during === 0) {
                confirmDialog.close();
            }
        }
    }
    onOpened: {
        during = autoClose;
        countDownTimer.start();
    }
    onClosed: {
        countDownTimer.stop();
    }
}
