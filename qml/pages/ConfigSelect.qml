/**
 * @file qml/pages/ConfigSelect.qml
 * @brief 配置文件选择页（启动页，configSetting = 0 时加载）
 *
 * 上半部：LCD 风格大时钟（"88:88:88" 底纹 + 冒号 500ms 闪烁）与日期；
 * 下半部：配置文件列表（ListView，数据来自 Global.configListModel），
 *   点选高亮某项后点击右侧 "»" 箭头确认，写入 Global.settings.configSetting，
 *   Main.qml 的 Loader 随即切到 Connect 连接页。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

Item {
    id: connectPage
    anchors.fill: parent
    anchors.margins: width * 0.02

    Column {
        width: parent.width
        height: parent.height
        spacing: height * 0.05
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
            Timer {
                id: timer
                property bool space: true
                interval: 500
                repeat: true
                running: true
                triggeredOnStart: true
                onTriggered: {
                    dateText.text = new Date().toLocaleDateString(
                        Qt.locale("zh_CN"), "yy年MM月dd日\n\rdddd")
                    if (space) {
                        timeText.text = new Date().toLocaleTimeString(
                            Qt.locale("zh_CN"), "hh mm ss")
                    } else {
                        timeText.text = new Date().toLocaleTimeString(
                            Qt.locale("zh_CN"), "hh:mm:ss")
                    }
                    space = !space
                }
            }
        }
        Rectangle {
            width: parent.width
            height: parent.height * 0.65
            //color: "transparent"
            color: Global.buttonColor
            radius: height / 20
            ListView {
                id: listView
                anchors.fill: parent
                clip: true
                ScrollBar.vertical: ScrollBar {}
                highlight: Rectangle {
                    color: Global.buttonCheckedColor
                    radius: height / 5
                    Text {
                        width: height
                        height: parent.height
                        font.pixelSize: height * 0.5
                        font.family: Global.alibabaPuHuiTi.font.family
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "\u00BB"
                        anchors.right: parent.right
                        MouseArea {
                            id: textMouseArea
                            anchors.fill: parent
                            onClicked: function (mouse) {
                                Global.settings.configSetting = listView.currentIndex
                            }
                        }
                    }
                }
                highlightFollowsCurrentItem: true // 高亮跟随当前项移动亮
                anchors.margins: height * 0.1
                model: Global.configListModel
                delegate: Text {
                    required property string modelData
                    required property int index
                    text: modelData
                    width: listView.width
                    height: listView.height * 0.2
                    font.pixelSize: height * 0.5
                    color: Global.buttonTextColor
                    font.family: Global.alibabaPuHuiTi.font.family
                    leftPadding: height / 2
                    verticalAlignment: Text.AlignVCenter
                    MouseArea {
                        anchors.fill: parent
                        propagateComposedEvents: true
                        onClicked: function (mouse) {
                            listView.currentIndex = parent.index
                            mouse.accepted = false
                        }
                    }
                }
            }
        }
    }
}
