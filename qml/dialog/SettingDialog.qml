/**
 * @file SettingDialog.qml
 * @brief 系统设置对话框（密码验证通过后打开）
 *
 * 设置项（Grid 两列布局）：
 *   配置选择（ComboBox）、中控 IP/端口/IPID、全屏、演示模式（连接演示服务器）、
 *   深浅主题、阴影（低/高性能）、显示通道号、设置密码。
 * 按钮：应用（apply 不关闭）、确定（accept → apply）、取消（回滚所有显示值并 sync）；
 * apply() 中：配置/网络/IPID 变化或演示模式切换时发 disConnect 信号断开重连，
 * 演示模式切换时还会清空全部 digital/analog 反馈，最后 Global.settings.sync() 持久化。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Fusion

import "../"
import "../Custom"

Dialog {
    id: rootSetting

    anchors.centerIn: Overlay.overlay

    implicitWidth: Overlay.overlay.width * 0.9
    implicitHeight: Overlay.overlay.height * 0.9

    modal: true

    closePolicy: Popup.NoAutoClose

    signal disConnect

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

    background: Background {}

    Column {
        anchors.fill: parent
        anchors.margins: height * 0.05
        spacing: height * 0.05
        Row {
            id: settingButtons
            width: parent.width
            height: parent.height * 0.22
            spacing: width * 0.02
            layoutDirection: Qt.RightToLeft

            ColorButton {
                id: settingOK
                width: parent.width * 0.2
                height: parent.height * 0.6
                text: "确定"
                onClicked: rootSetting.accept()
                btnColor: Global.buttonColor
            }
            ColorButton {
                id: settingApply
                width: parent.width * 0.2
                height: parent.height * 0.6
                text: "应用"
                onClicked: rootSetting.apply()
            }
            ColorButton {
                id: settingCancel
                width: parent.width * 0.2
                height: parent.height * 0.6
                text: "取消"
                onClicked: rootSetting.reject()
            }
            Text {
                width: parent.width * 0.34
                height: parent.height
                text: "系统设置请勿随意修改\nV" + Global.configList[Global.settings.configSetting].version
                font.pixelSize: height * 0.2
                horizontalAlignment: Text.AlignLeft
                color: Global.buttonTextColor
                font.family: Global.alibabaPuHuiTi.font.family
            }
        }
        ScrollView {
            id: scrollView
            width: parent.width
            height: parent.height * 0.73
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            contentWidth: parent.width
            clip: true
            Behavior on ScrollBar.vertical.position {
                NumberAnimation {
                    duration: Global.durationDelay
                }
            }
            Grid {
                id: gridview
                width: parent.width
                bottomPadding: scrollView.height * 0.02
                columns: 2
                spacing: scrollView.height * 0.01
                Text {
                    text: "配置选择"
                    width: parent.width * 0.34
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                }
                ComboBox {
                    id: configComboBox
                    width: parent.width * 0.64
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.6
                    font.family: Global.alibabaPuHuiTi.font.family
                    model: Global.configListModel
                    currentIndex: Global.settings.configSetting
                    delegate: ItemDelegate {
                        id: delegate
                        required property var model
                        required property int index
                        contentItem: Text {
                            text: delegate.model[configComboBox.textRole]
                            color: Global.buttonTextColor
                            font: configComboBox.font
                            elide: Text.ElideRight
                        }
                        highlighted: configComboBox.highlightedIndex === index
                        background: Rectangle {
                            color: delegate.highlighted ? Global.buttonColor : "transparent"
                        }
                    }

                    contentItem: Text {
                        leftPadding: 4
                        text: configComboBox.displayText
                        font: configComboBox.font
                        color: Global.buttonTextColor
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    indicator: MyIconLabel {
                        icon.source: configComboBox.down ? "qrc:/icons/down2" : "qrc:/icons/down"
                        icon.color: Global.buttonTextColor
                        width: parent.height
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                    }
                    background: Rectangle {
                        color: "transparent"
                        border.color: Global.buttonTextColor
                        radius: height / 10
                    }

                    popup: Popup {
                        id: popup
                        y: configComboBox.height
                        width: configComboBox.width
                        font.pixelSize: parent.height * 0.7

                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: configComboBox.delegateModel
                            currentIndex: configComboBox.highlightedIndex
                        }

                        background: Rectangle {
                            color: Global.backgroundColor
                            border.color: Global.buttonTextColor
                            radius: 4
                        }
                    }
                }
                Text {
                    text: "中控IP地址"
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                }

                TextField {
                    id: ipAddress
                    width: parent.width * 0.64
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.6
                    text: Global.settings.ipAddress
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: RegularExpressionValidator {
                        regularExpression: /(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}/
                    }
                    color: acceptableInput ? Global.buttonTextColor : Global.buttonWarnColor
                    onFocusChanged: {
                        if (focus) {
                            scrollView.ScrollBar.vertical.position = y / scrollView.height;
                        }
                    }
                    font.family: Global.alibabaPuHuiTi.font.family
                    background: Rectangle {
                        color: "transparent"
                        border.color: Global.buttonTextColor
                        radius: height / 10
                    }
                    enabled: !demoMode.checked
                    opacity: enabled ? 1 : Global.disableOpacity / 2
                }

                Text {
                    text: "中控端口"
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                }
                TextField {
                    id: ipPort
                    width: parent.width * 0.64
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.6
                    text: Global.settings.ipPort
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 1024
                        top: 49151
                    }
                    color: acceptableInput ? Global.buttonTextColor : Global.buttonWarnColor
                    onFocusChanged: {
                        if (focus) {
                            scrollView.ScrollBar.vertical.position = y / scrollView.height;
                        }
                    }
                    font.family: Global.alibabaPuHuiTi.font.family
                    background: Rectangle {
                        color: "transparent"
                        border.color: Global.buttonTextColor
                        radius: height / 10
                    }
                    enabled: !demoMode.checked
                    opacity: enabled ? 1 : Global.disableOpacity / 2
                }

                Text {
                    text: "程序IPID"
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                }
                TextField {
                    id: ipId
                    width: parent.width * 0.64
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.6
                    text: Global.settings.ipId
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 1
                        top: 255
                    }
                    color: acceptableInput ? Global.buttonTextColor : Global.buttonWarnColor
                    onFocusChanged: {
                        if (focus) {
                            scrollView.ScrollBar.vertical.position = y / scrollView.height;
                        }
                    }
                    font.family: Global.alibabaPuHuiTi.font.family
                    background: Rectangle {
                        color: "transparent"
                        border.color: Global.buttonTextColor
                        radius: height / 10
                    }
                    enabled: !demoMode.checked
                    opacity: enabled ? 1 : Global.disableOpacity / 2
                }

                Text {
                    text: "系统设置密码"
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                }

                TextField {
                    id: settingPassword
                    width: parent.width * 0.64
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.6
                    text: Global.settings.settingPassword
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 0
                        top: 999999
                    }
                    color: acceptableInput ? Global.buttonTextColor : Global.buttonWarnColor
                    onFocusChanged: {
                        if (focus) {
                            scrollView.ScrollBar.vertical.position = y / scrollView.height;
                        }
                    }
                    font.family: Global.alibabaPuHuiTi.font.family
                    background: Rectangle {
                        color: "transparent"
                        border.color: Global.buttonTextColor
                        radius: height / 10
                    }
                }
                Text {
                    text: fullscreen.checked ? "全屏显示" : "窗口显示"
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                    visible: Qt.platform.os === "windows"
                }
                ColorSwitch {
                    id: fullscreen
                    height: scrollView.height / 10
                    width: height * 1.6
                    checked: Global.settings.fullscreen
                    visible: Qt.platform.os === "windows"
                }
                Text {
                    text: showChannel.checked ? "显示调试信息" : "隐藏调试信息"
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                }
                ColorSwitch {
                    id: showChannel
                    height: scrollView.height / 10
                    width: height * 1.6
                    checked: Global.settings.showChannel
                }
                Text {
                    text: darkTheme.checked ? "深色主题" : "浅色主题"
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                }
                ColorSwitch {
                    id: darkTheme
                    height: scrollView.height / 10
                    width: height * 1.6
                    checked: Global.settings.darkTheme
                }
                Text {
                    text: demoMode.checked ? "演示模式" : "正常模式"
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                }
                ColorSwitch {
                    id: demoMode
                    height: scrollView.height / 10
                    width: height * 1.6
                    checked: Global.settings.demoMode
                }
                Text {
                    text: shadow.checked ? "高性能" : "低性能"
                    height: scrollView.height / 10
                    font.pixelSize: height * 0.7
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                }
                ColorSwitch {
                    id: shadow
                    height: scrollView.height / 10
                    width: height * 1.6
                    checked: Global.settings.shadow
                }
            }
        }
    }

    onAccepted: {
        apply();
    }

    onOpened: {
        darkTheme.checked = Global.settings.darkTheme;
    }

    onRejected: {
        configComboBox.currentIndex = Global.settings.configSetting;
        ipAddress.text = Global.settings.ipAddress;
        ipPort.text = Global.settings.ipPort;
        ipId.text = Global.settings.ipId;
        fullscreen.checked = Global.settings.fullscreen;
        demoMode.checked = Global.settings.demoMode;
        settingPassword.text = Global.settings.settingPassword;
        showChannel.checked = Global.settings.showChannel;
        darkTheme.checked = Global.settings.darkTheme;
        shadow.checked = Global.settings.shadow;
        Global.settings.sync();
    }

    function apply() {
        if (Global.settings.configSetting !== configComboBox.currentIndex) {
            Global.settings.configSetting = configComboBox.currentIndex;
            disConnect();
        }
        if ((Global.settings.ipAddress != ipAddress.text) || (Global.settings.ipPort != ipPort.text) || (Global.settings.ipId != ipId.text)) {
            Global.settings.ipAddress = ipAddress.text;
            Global.settings.ipPort = ipPort.text;
            Global.settings.ipId = ipId.text;
            disConnect();
        }
        Global.settings.fullscreen = fullscreen.checked;
        if (Global.settings.demoMode !== demoMode.checked) {
            disConnect();
            for (var i = 0; i <= 300; i++) {
                Global.digital[i] = false;
                Global.analog[i] = 0;
            }
            Global.settings.demoMode = demoMode.checked;
        }
        Global.settings.settingPassword = settingPassword.text;
        if (Global.settings.showChannel !== showChannel.checked) {
            Global.settings.showChannel = showChannel.checked;
        }
        Global.settings.darkTheme = darkTheme.checked;
        Global.settings.shadow = shadow.checked;
        Global.settings.sync();
    }
}
