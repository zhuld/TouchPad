/**
 * @file Mediaplayer/PPT.qml
 * @brief PPT 演示页（媒体播放器）
 *
 * 左卡片"PPT 内容"：PPT 1~5 选择（D51~55）；
 * 右卡片"控制"：前一页/后一页/第一页/最后一页/停止（D56~60）。
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
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("PPT内容")
            content: Grid {
                id: gridPPT
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listOutput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listOutput
                        ListElement {
                            name: qsTr("PPT 1")
                            btnchannel: 51
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/ppt"
                        }
                        ListElement {
                            name: qsTr("PPT 2")
                            btnchannel: 52
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/ppt"
                        }
                        ListElement {
                            name: qsTr("PPT 3")
                            btnchannel: 53
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/ppt"
                        }
                        ListElement {
                            name: qsTr("PPT 4")
                            btnchannel: 54
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/ppt"
                        }
                        ListElement {
                            name: qsTr("PPT 5")
                            btnchannel: 55
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/ppt"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property string iconUrl
                        width: (gridPPT.width + gridPPT.spacing) / gridPPT.columns - gridPPT.spacing
                        height: (gridPPT.height + gridPPT.spacing) / gridPPT.rows - gridPPT.spacing
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
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("控制")
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
                            name: qsTr("前一页")
                            btnchannel: 56
                            iconUrl: "qrc:/icons/qianyige"
                        }
                        ListElement {
                            name: qsTr("后一页")
                            btnchannel: 57
                            iconUrl: "qrc:/icons/houyige"
                        }
                        ListElement {
                            name: qsTr("第一页")
                            btnchannel: 58
                            iconUrl: "qrc:/icons/zuiqian"
                        }
                        ListElement {
                            name: qsTr("最后一页")
                            btnchannel: 59
                            iconUrl: "qrc:/icons/zuihou"
                        }
                        ListElement {
                            name: qsTr("停止")
                            btnchannel: 60
                            iconUrl: "qrc:/icons/tingzhibofang"
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
