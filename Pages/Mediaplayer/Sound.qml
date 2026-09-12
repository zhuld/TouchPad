/**
 * @file Mediaplayer/Sound.qml
 * @brief 背景音乐页（媒体播放器）
 *
 * 左卡片"背景音乐内容"：Sound 1~3 选择（D31~33）；
 * 右卡片"控制"：停止/暂停/恢复/下一首（D34~37）。
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
            Layout.maximumWidth: parent.width * 0.3
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("背景音乐内容")
            backIcon: "qrc:/icons/music"
            content: Grid {
                id: gridSound
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listOutput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listOutput
                        ListElement {
                            name: qsTr("Sound 1")
                            btnchannel: 31
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/music"
                        }
                        ListElement {
                            name: qsTr("Sound 2")
                            btnchannel: 32
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/music"
                        }
                        ListElement {
                            name: qsTr("Sound 3")
                            btnchannel: 33
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/music"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property string iconUrl
                        width: (gridSound.width + gridSound.spacing)
                               / gridSound.columns - gridSound.spacing
                        height: (gridSound.height + gridSound.spacing)
                                / gridSound.rows - gridSound.spacing
                        text: name
                        channel: btnchannel
                        disableChannel: disBtnChannel
                        source: iconUrl
                    }
                }
            }
        }

        Category {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.7
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("控制")
            backIcon: "qrc:/icons/music"
            content: Grid {
                id: gridControl
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listInput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listInput
                        ListElement {
                            name: qsTr("停止")
                            btnchannel: 34
                            iconUrl: "qrc:/icons/tingzhibofang"
                        }
                        ListElement {
                            name: qsTr("暂停")
                            btnchannel: 35
                            iconUrl: "qrc:/icons/zanting"
                        }
                        ListElement {
                            name: qsTr("恢复")
                            btnchannel: 36
                            iconUrl: "qrc:/icons/bofang"
                        }
                        ListElement {
                            name: qsTr("下一首")
                            btnchannel: 37
                            iconUrl: "qrc:/icons/houyige"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property string iconUrl
                        width: (gridControl.width + gridControl.spacing)
                               / gridControl.columns - gridControl.spacing
                        height: (gridControl.height + gridControl.spacing)
                                / gridControl.rows - gridControl.spacing
                        text: name
                        channel: btnchannel
                        source: iconUrl
                    }
                }
            }
        }
    }
}
