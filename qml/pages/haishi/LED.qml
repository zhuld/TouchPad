/**
 * @file qml/pages/haishi/LED.qml
 * @brief LED 屏控制页（海事大学）
 *
 * 左卡片"亮度"：VolumeBar 复用为亮度滑条（模拟量 A1，量程 0~10，
 *   muteChannel=0 且 muteBtn=false 表示不显示静音键）；
 * 中卡片"LED 控制"：电源开/关、屏幕显示/黑屏（D23~27，长按 1 秒生效）；
 * 右侧为透明占位块，仅用于三列布局配重。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Item {
    implicitWidth: parent.width
    implicitHeight: parent.height

    RowLayout {
        anchors.fill: parent
        Category {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.25
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("亮度")
            content: VolumeBar {
                anchors.fill: parent
                channel: 1
                muteChannel: 0
                miniVolume: 0
                maxVolume: 10
                muteBtn: false
            }
        }
        Category {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.6
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("LED控制")
            info: MyIconLabel {
                height: parent.height
                icon.source: "qrc:/icons/tishi"
                text: qsTr("长按1秒运行")
            }
            content: Grid {
                id: gridLed
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(ledList.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: ledList
                        ListElement {
                            name: qsTr("电源开")
                            btnchannel: 23
                            iconUrl: "qrc:/icons/guanji"
                        }
                        ListElement {
                            name: qsTr("电源关")
                            btnchannel: 24
                            iconUrl: "qrc:/icons/guanji"
                        }
                        ListElement {
                            name: qsTr("屏幕显示")
                            btnchannel: 27
                            iconUrl: "qrc:/icons/guanji"
                        }
                        ListElement {
                            name: qsTr("屏幕黑屏")
                            btnchannel: 26
                            iconUrl: "qrc:/icons/guanji"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property string iconUrl
                        width: (gridLed.width + gridLed.spacing) / gridLed.columns - gridLed.spacing
                        height: (gridLed.height + gridLed.spacing) / gridLed.rows - gridLed.spacing
                        text: name
                        channel: btnchannel
                        source: iconUrl
                    }
                }
            }
        }

        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.2
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
        }
    }
}
