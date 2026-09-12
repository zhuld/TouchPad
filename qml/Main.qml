/**
 * @file qml/Main.qml
 * @brief 主窗口（TouchPad 模块根组件）
 *
 * 职责：
 *   1. 承载三个全局对话框：密码框、系统设置、关闭确认；
 *   2. 根据连接状态与当前配置切换页面：
 *      未选配置 → ConfigSelect；已选未连 → Connect；已连接 → ContentColumn/ContentRow；
 *   3. 提供无边框窗口的自绘标题栏（Logo/标题/时钟/主题/设置/关闭）
 *      与右/下边缘的等比缩放热区（Windows 桌面场景）；
 *   4. 心跳保活（每 10s 发送 CIP Ping）与 CIP 协议消息的顶层分发。
 */
import QtQuick

import "./js/crestroncip.js" as CrestronCIP
import "./dialog"

Window {
    id: root

    // ======================== 全局对话框 ========================

    /// 设置页密码框：密码正确才打开设置对话框（"314159" 为内置万能密码）
    PasswordDialog {
        id: passwordDialog
        onPasswordEnter: password => {
            if ((password === "314159") | (password === Global.settings.settingPassword)) {
                settingDialog.open();
                passwordDialog.close();
            } else {
                passwordDialog.error = true;
            }
        }
    }

    /// 系统设置对话框：修改配置文件/网络/IPID 等
    SettingDialog {
        id: settingDialog
        onDisConnect: {
            TcpClient.disconnectFromServer();
        }
    }

    /// 关闭程序确认框
    ConfirmDialog {
        id: closeDialog
        dialogIcon: "qrc:/icons/tishi"
        dialogInfomation: "确定关闭程序？"
        dialogTitle: "提示"
        onAccepted: {
            closeDialog.close();
            root.close();
        }
    }

    // ======================== 心跳保活 ========================

    // 心跳开关（暴露给协议层）：IPID 注册成功后置 true，断开后置 false
    property alias running: ping.running

    /// 心跳定时器：每 10 秒向中控发送一次 CIP Ping 保活
    Timer {
        id: ping
        interval: 10000
        repeat: true
        onTriggered: {
            CrestronCIP.ping();
        }
    }

    // ======================== 窗口基本属性 ========================
    // 尺寸记忆上次缩放结果；标题 = 当前配置的 "Logo名 + 标题名"
    width: Global.settings.windowWidth
    height: Global.settings.windowHeight
    minimumWidth: 400
    minimumHeight: 250
    color: Global.backgroundColor

    title: Global.configList[Global.settings.configSetting].logoName + Global.configList[Global.settings.configSetting].titleName

    visibility: Global.settings.fullscreen ? Window.FullScreen : Window.Windowed
    flags: Qt.FramelessWindowHint | Qt.Window

    /// 页面背景图（连接之前压得较亮，连接后变暗以突出控制界面）
    Image {
        anchors.fill: parent
        source: Global.configList[Global.settings.configSetting].background
        opacity: ping.running ? 0.3 : 0.6
    }


    // ======================== 自绘标题栏 ========================
    //titlebar
    Item {
        id: titleBar
        width: parent.width * 0.96
        height: parent.height * 0.04
        anchors.horizontalCenter: parent.horizontalCenter

        /// 标题栏拖动：按住可移动无边框窗口（全屏时禁用）
        MouseArea {
            property point clickPosition: Qt.point(0, 0)
            anchors.fill: parent
            cursorShape: Global.settings.fullscreen ? Qt.ArrowCursor : Qt.SizeAllCursor
            onPositionChanged: {
                if (!pressed || Global.settings.fullscreen)
                    return;
                root.x += mouseX - clickPosition.x;
                root.y += mouseY - clickPosition.y;
            }
            onPressed: clickPosition = Qt.point(mouseX, mouseY)
        }

        /// 左上角场所 Logo 文字
        MyIconLabel {
            id: titleLogo
            text: Global.configList[Global.settings.configSetting].logoName
            height: parent.height
            anchors.left: parent.left
            font.pixelSize: height * 0.7
        }

        /// 居中标题文字
        MyIconLabel {
            id: titleName
            text: Global.configList[Global.settings.configSetting].titleName
            height: parent.height
            anchors.centerIn: parent
            font.pixelSize: height * 0.7
        }

        /// 右侧控件列：时钟、深浅主题切换、设置按钮、关闭按钮
        Row {
            height: parent.height
            anchors.right: parent.right
            spacing: parent.width * 0.01

            /// 实时时钟：每秒刷新，按 zh_CN 格式显示 "hh:mm"
            MyIconLabel {
                id: titleTime
                height: parent.height
                font.pixelSize: height * 0.7
                Timer {
                    id: timer
                    interval: 1000
                    repeat: true
                    running: true
                    triggeredOnStart: true
                    onTriggered: {
                        titleTime.text = new Date().toLocaleTimeString(Qt.locale("zh_CN"), " hh:mm");
                    }
                }
            }

            /// 深浅主题切换开关（仅 Windows 桌面显示）
            ColorSwitch {
                id: themeSwtich
                height: parent.height * 0.8
                width: height
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    Global.settings.darkTheme = !Global.settings.darkTheme;
                }
                checked: Global.settings.darkTheme
                visible: Qt.platform.os === "windows" ? true : false
            }

            /// 设置按钮：先弹出密码框，验证通过后打开设置对话框
            ColorButton {
                id: setup
                height: parent.height
                width: height
                source: "qrc:/icons/config"
                onClicked: passwordDialog.open()
                btnColor: "transparent"
                btnCheckColor: "transparent"
            }

            /// 关闭按钮：弹出关闭确认框（仅 Windows 桌面显示）
            ColorButton {
                id: close
                height: parent.height
                width: height
                source: "qrc:/icons/close"
                btnColor: "transparent"
                btnCheckColor: "transparent"
                onClicked: closeDialog.open()
                visible: Qt.platform.os === "windows" ? true : false
            }
        }
    }

    // ======================== 窗口边缘等比缩放热区 ========================
    // 两个热区都按最小宽高比（minimumWidth/minimumHeight）等比缩放，
    // 松开时把结果写回 Global.settings 以便下次启动恢复尺寸。

    /// 右侧热区：水平拖拽按宽高比等比缩放窗口（全屏时禁用）
    MouseArea {
        id: rightSide
        height: parent.height * 0.96
        width: parent.width * 0.01
        cursorShape: Global.settings.fullscreen ? Qt.ArrowCursor : Qt.SizeHorCursor
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        onPositionChanged: {
            if (!pressed || Global.settings.fullscreen)
                return;
            // 以鼠标位移推算新宽度，再按比例同步高度
            let width = root.width + mouseX;
            if (width > root.minimumWidth) {
                root.width = width;
            } else {
                root.width = root.minimumWidth;
            }
            let height = width / root.minimumWidth * root.minimumHeight;
            if (height > root.minimumHeight) {
                root.height = height;
            } else {
                root.height = root.minimumHeight;
            }
        }
        onReleased: {
            Global.settings.windowWidth = root.width;
            Global.settings.windowHeight = root.height;
        }
    }

    /// 底部热区：垂直拖拽按宽高比等比缩放窗口（全屏时禁用）
    MouseArea {
        id: bottomSide
        height: parent.width * 0.01
        width: parent.width * 0.98
        cursorShape: Global.settings.fullscreen ? Qt.ArrowCursor : Qt.SizeVerCursor
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onPositionChanged: {
            if (!pressed || Global.settings.fullscreen)
                return;
            // 以鼠标位移推算新高度，再按比例同步宽度
            let height = root.height + mouseY;
            if (height > root.minimumHeight) {
                root.height = height;
            } else {
                root.height = root.minimumHeight;
            }
            let width = height * root.minimumWidth / root.minimumHeight;
            if (width > root.minimumWidth) {
                root.width = width;
            } else {
                root.width = root.minimumWidth;
            }
        }
        onReleased: {
            Global.settings.windowWidth = root.width;
            Global.settings.windowHeight = root.height;
        }
    }

    // ======================== 页面加载 ========================

    /// 页面加载器：根据连接状态与配置切换加载的页面
    Loader {
        id: pageLoader
        anchors.top: titleBar.bottom
        width: parent.width
        height: parent.height - titleBar.height
        // 已连接：标签在底部用 ContentRow，否则用 ContentColumn；
        // 未连接：未选配置进 ConfigSelect，已选配置进 Connect 连接页
        source: ping.running ? (Global.configList[Global.settings.configSetting].tabOnBottom ? "pages/ContentRow.qml" : "pages/ContentColumn.qml") : (Global.settings.configSetting === 0 ? "pages/ConfigSelect.qml" : "pages/Connect.qml")
    }

    // ======================== 协议信号分发 ========================

    /// 中控连接信号分发：断开→停止心跳返回连接页；收到数据→交给客户端 CIP 解析
    Connections {
        target: TcpClient
        function onStateChanged(state) {
            // UnconnectedState：断开连接后停止心跳，Loader 会切回连接页
            if (state === 0) {
                ping.running = false;
            }
        }
        function onDataReceived(data) {
            CrestronCIP.clientMessageCheck(new Uint8Array(data));
        }
    }

    /// 演示服务器信号分发：收到数据→服务器端 CIP 解析；新客户端接入→先发确认包
    Connections {
        target: TcpServer
        function onDataReceived(data) {
            CrestronCIP.serverMessageCheck(new Uint8Array(data));
        }
        function onClientConnected() {
            CrestronCIP.serverAccept();
        }
    }
}

