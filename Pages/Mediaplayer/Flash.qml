/**
 * @file Mediaplayer/Flash.qml
 * @brief Flash 播放页（媒体播放器）
 *
 * 左卡片"Flash 内容"：Flash 1~5 选择（D61~65）；
 * 右侧为透明占位块（无控制项）。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Item {
    anchors.fill: parent
    RowLayout {
        anchors.fill: parent
        Category {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("Flash内容")
            backIcon: "qrc:/icons/flash"
            content: Grid {
                id: gridFlash
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listOutput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listOutput
                        ListElement {
                            name: qsTr("Flash 1")
                            btnchannel: 61
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/flash"
                        }
                        ListElement {
                            name: qsTr("Flash 2")
                            btnchannel: 62
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/flash"
                        }
                        ListElement {
                            name: qsTr("Flash 3")
                            btnchannel: 63
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/flash"
                        }
                        ListElement {
                            name: qsTr("Flash 4")
                            btnchannel: 64
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/flash"
                        }
                        ListElement {
                            name: qsTr("Flash 5")
                            btnchannel: 65
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/flash"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property string iconUrl
                        width: (gridFlash.width + gridFlash.spacing)
                               / gridFlash.columns - gridFlash.spacing
                        height: (gridFlash.height + gridFlash.spacing)
                                / gridFlash.rows - gridFlash.spacing
                        text: name
                        channel: btnchannel
                        disableChannel: disBtnChannel
                        source: iconUrl
                    }
                }
            }
        }

        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
        }
    }
}
