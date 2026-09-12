/**
 * @file qml/dialog/PasswordDialog.qml
 * @brief 设置入口密码框（进入系统设置前的身份验证）
 *
 * 界面：3x4 数字键盘（0-9、退格 ⤺、确认 ⤍），最多输入 6 位；
 * 交互：确认时发 passwordEnter(password) 信号由 Main.qml 校验；
 *       密码错误时置 error=true，标题抖动并提示"密码错误"；
 * autoClose（默认 30s）倒计时自动关闭；点击对话框外部关闭并清空输入。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

Dialog {
    id: rootPassword

    readonly property real ratio: 0.9
    property int autoClose: 30
    property int during
    property bool error: false

    onErrorChanged: {
        if (error) {
            passwordTitle.text = "请输入密码：  密码错误";
            error = false;
            passwordAnimation.start();
        }
    }

    implicitWidth: Overlay.overlay.width / Overlay.overlay.height < ratio ? Overlay.overlay.width * 0.9 : Overlay.overlay.height * 0.9 * ratio
    implicitHeight: implicitWidth / ratio

    signal passwordEnter(string password)

    anchors.centerIn: Overlay.overlay

    modal: true
    closePolicy: Popup.CloseOnPressOutside

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

    Timer {
        id: countDownTimer
        interval: 1000
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            parent.during--;
            if (parent.during === 0) {
                rootPassword.close();
            }
        }
    }
    onOpened: {
        passwordTitle.text = "请输入密码：";
        during = autoClose;
        countDownTimer.start();
    }

    onClosed: {
        passwordTitle.text = "请输入密码：";
        password.text = "";
        rootPassword.error = false;
        countDownTimer.stop();
    }
    background: Background {}

    Column {
        id: base
        anchors.fill: parent
        anchors.margins: width * 0.02
        spacing: height * 0.02
        MyIconLabel {
            id: passwordTitle
            height: parent.height * 0.06
            color: Global.buttonTextColor
            text: "请输入密码："
            font.pixelSize: height

            PropertyAnimation on x {
                id: passwordAnimation
                property int originVal
                from: -10
                to: 10
                duration: 100
                easing.type: Easing.InOutSine
                loops: 3
                onFinished: passwordTitle.x = 0
            }
        }

        TextInput {
            id: password
            x: parent.width * 0.03
            width: parent.width
            height: parent.height * 0.17
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: height * 0.4
            font.letterSpacing: parent.width * 0.06
            color: Global.buttonTextColor
            enabled: false
            focus: true
            echoMode: TextInput.Password
            passwordMaskDelay: 500
            font.family: Global.alibabaPuHuiTi.font.family
        }

        Grid {
            id: numberPad
            width: parent.width * 0.6
            height: width * 1.33
            anchors.margins: parent.width * 0.1
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 3
            spacing: width * 0.05
            Repeater {
                model: ListModel {
                    id: numberModel
                    ListElement {
                        name: "1"
                    }
                    ListElement {
                        name: "2"
                    }
                    ListElement {
                        name: "3"
                    }
                    ListElement {
                        name: "4"
                    }
                    ListElement {
                        name: "5"
                    }
                    ListElement {
                        name: "6"
                    }
                    ListElement {
                        name: "7"
                    }
                    ListElement {
                        name: "8"
                    }
                    ListElement {
                        name: "9"
                    }
                    ListElement {
                        name: "\u21E6"
                    }
                    ListElement {
                        name: "0"
                    }
                    ListElement {
                        name: "\u23CE"
                    }
                }
                delegate: ColorButton {
                    required property string name
                    width: (numberPad.width + numberPad.spacing) / numberPad.columns - numberPad.spacing
                    height: width
                    radius: height / 2
                    text: name
                    enabled: (text === "\u21E6" & password.text === "") ? 0 : 1
                    onClicked: {
                        switch (name) {
                        case "1":
                        case "2":
                        case "3":
                        case "4":
                        case "5":
                        case "6":
                        case "7":
                        case "8":
                        case "9":
                        case "0":
                            if (password.text.length < 6) {
                                password.text += name;
                            }
                            break;
                        case "\u21E6":
                            password.text = password.text.slice(0, password.text.length - 1);
                            break;
                        case "\u23CE":
                            rootPassword.passwordEnter(password.text);
                            password.text = "";
                            break;
                        }
                    }
                }
            }
        }
    }
}
