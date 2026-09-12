/**
 * @file Connect.qml
 * @brief 连接页（已选配置、等待与中控建立连接）
 *
 * 上半部：与 ConfigSelect 相同的 LCD 风格时钟；
 * 下半部："正在连接中控..." 提示、目标地址标签（IP:端口@IPID，含错误信息）。
 * 逻辑：
 *   - onCompleted：清空全部 digital/digitalToggle/analog 反馈、断开旧连接，
 *     并启动演示服务器（TcpServer，模拟中控端，仅演示模式有实际作用）；
 *   - 500ms 定时器：第 3 拍时按演示/正常模式发起连接（避免时钟未就绪），
 *     之后每 5s 重启一次底部进度条动画表示"仍在尝试"；
 *   - TcpClient.onErrorOccurred 时把错误显示在地址标签后。
 */

import QtQuick

Item {
    id: connectPage
    anchors.fill: parent
    anchors.margins: width * 0.02

    Column {
        width: parent.width
        height: parent.height
        spacing: height * 0.08
        Row {
            width: parent.width
            height: parent.height * 0.3
            spacing: width * 0.05
            Text {
                id: timeText
                width: parent.width * 0.58
                height: parent.height
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height * 0.8
                color: Global.buttonTextColor
                font.family: Global.lcdFont.font.family
                Text {
                    width: parent.width
                    height: parent.height
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height * 0.8
                    opacity: 0.03
                    font.family: Global.lcdFont.font.family
                    text: "88:88:88"
                }
            }
            Rectangle {
                height: parent.height * 0.6
                y: parent.height * 0.2
                width: 2
                color: Global.buttonTextColor
            }
            Text {
                id: dateText
                width: parent.width * 0.32
                height: parent.height
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height * 0.23
                color: Global.buttonTextColor
                font.family: Global.alibabaPuHuiTi.font.family
            }
        }
        Timer {
            id: timer
            property bool space: true
            property int count: 0
            interval: 500
            repeat: true
            running: true
            triggeredOnStart: false
            onTriggered: {
                dateText.text = new Date().toLocaleDateString(Qt.locale("zh_CN"), "yy年MM月dd日\n\rdddd");
                if (space) {
                    timeText.text = new Date().toLocaleTimeString(Qt.locale("zh_CN"), "hh mm ss");
                } else {
                    timeText.text = new Date().toLocaleTimeString(Qt.locale("zh_CN"), "hh:mm:ss");
                }
                space = !space;
                count++;
                if (count == 3) {
                    if (Global.settings.demoMode)
                        TcpClient.connectToServer(Global.demoIP, Global.demoPort);
                    else
                        TcpClient.connectToServer(Global.settings.ipAddress, Global.settings.ipPort);
                } else if (count > 10) {
                    count = 0;
                    socketAnimation.start();
                }
            }
        }
        MyIconLabel {
            text: qsTr("正在连接中控...  ")
            height: parent.height * 0.25
            color: Global.buttonTextColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        MyIconLabel {
            id: connetLabel
            property string errorString: ''
            text: Global.settings.demoMode ? (Global.demoIP + ":" + Global.demoPort + "@" + Global.demoIPID + ' ' + errorString) : (Global.settings.ipAddress + ":" + Global.settings.ipPort + "@" + Global.settings.ipId + ' ' + errorString)
            height: parent.height * 0.08
            color: Global.buttonTextColor
            anchors.right: parent.right
        }
        Connections {
            target: TcpClient
            function onErrorOccurred(error) {
                connetLabel.errorString = error;
            }
        }
        Rectangle {
            id: socketStatusProgress
            property real socketValue: 1
            width: parent.width * socketValue
            height: 6
            radius: height / 2
            color: Global.buttonCheckedColor
            NumberAnimation {
                id: socketAnimation
                target: socketStatusProgress
                property: "socketValue"
                from: 0
                to: 1
                duration: 5000
                running: true
            }
        }
    }
    Component.onCompleted: {
        for (var i = 0; i <= 300; i++) {
            Global.digital[i] = false;
            Global.digitalToggle[i] = false;
            Global.analog[i] = 0;
        }
        TcpClient.disconnectFromServer();
        TcpServer.stopServer();
        TcpServer.startServer(Global.demoPort, Global.demoIP);
    }
}
