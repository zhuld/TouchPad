/**
 * @file qml/pages/mediaplayer/Movie.qml
 * @brief 视频播放页（媒体播放器）
 *
 * 左卡片"视频内容"：Movie 1~5 播放选择（D21~25）；
 * 右卡片"控制"：停止/暂停/恢复（D27~29）。
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
            Layout.maximumWidth: parent.width * 0.7
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("视频内容")
            backIcon: "qrc:/icons/shipin"
            content: Grid {
                id: gridMovie
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listOutput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listOutput
                        ListElement {
                            name: qsTr("Movie 1")
                            btnchannel: 21
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/shipin"
                        }
                        ListElement {
                            name: qsTr("Movie 2")
                            btnchannel: 22
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/shipin"
                        }
                        ListElement {
                            name: qsTr("Movie 3")
                            btnchannel: 23
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/shipin"
                        }
                        ListElement {
                            name: qsTr("Movie 4")
                            btnchannel: 24
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/shipin"
                        }
                        ListElement {
                            name: qsTr("Movie 5")
                            btnchannel: 25
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/shipin"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property string iconUrl
                        width: (gridMovie.width + gridMovie.spacing)
                               / gridMovie.columns - gridMovie.spacing
                        height: (gridMovie.height + gridMovie.spacing)
                                / gridMovie.rows - gridMovie.spacing
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
            Layout.maximumWidth: parent.width * 0.3
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("控制")
            backIcon: "qrc:/icons/shipin"
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
                            btnchannel: 27
                            iconUrl: "qrc:/icons/tingzhibofang"
                        }
                        ListElement {
                            name: qsTr("暂停")
                            btnchannel: 28
                            iconUrl: "qrc:/icons/zanting"
                        }
                        ListElement {
                            name: qsTr("恢复")
                            btnchannel: 29
                            iconUrl: "qrc:/icons/bofang"
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
