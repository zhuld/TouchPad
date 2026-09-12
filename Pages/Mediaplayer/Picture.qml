/**
 * @file Mediaplayer/Picture.qml
 * @brief 图片浏览页（媒体播放器）
 *
 * 左卡片"图片内容"：Picture 1~5 选择（D41~45）；
 * 右卡片"控制"：停止/前一幅/后一幅（D46~48）。
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
            label: qsTr("图片内容")
            content: Grid {
                id: gridPic
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listOutput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listOutput
                        ListElement {
                            name: qsTr("Pictrue 1")
                            btnchannel: 41
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/tupianji"
                        }
                        ListElement {
                            name: qsTr("Pictrue 2")
                            btnchannel: 42
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/tupianji"
                        }
                        ListElement {
                            name: qsTr("Pictrue 3")
                            btnchannel: 43
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/tupianji"
                        }
                        ListElement {
                            name: qsTr("Pictrue 4")
                            btnchannel: 44
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/tupianji"
                        }
                        ListElement {
                            name: qsTr("Pictrue 5")
                            btnchannel: 45
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/tupianji"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property string iconUrl
                        width: (gridPic.width + gridPic.spacing) / gridPic.columns - gridPic.spacing
                        height: (gridPic.height + gridPic.spacing) / gridPic.rows - gridPic.spacing
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
                            btnchannel: 46
                            iconUrl: "qrc:/icons/tingzhibofang"
                        }
                        ListElement {
                            name: qsTr("前一幅")
                            btnchannel: 47
                            iconUrl: "qrc:/icons/qianyige"
                        }
                        ListElement {
                            name: qsTr("后一幅")
                            btnchannel: 48
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
