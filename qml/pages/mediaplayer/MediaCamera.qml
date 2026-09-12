/**
 * @file qml/pages/mediaplayer/MediaCamera.qml
 * @brief 摄像头采集页（媒体播放器）
 *
 * 左卡片"摄像头模式"：Camera 1~5 选择（D101~105）；
 * 右卡片"控制"：停止（D110）。
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
            label: qsTr("摄像头模式")
            content: Grid {
                id: gridCamera
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listOutput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listOutput
                        ListElement {
                            name: qsTr("Camera 1")
                            btnchannel: 101
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/camera"
                        }
                        ListElement {
                            name: qsTr("Camera 2")
                            btnchannel: 102
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/camera"
                        }
                        ListElement {
                            name: qsTr("Camera 3")
                            btnchannel: 103
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/camera"
                        }
                        ListElement {
                            name: qsTr("Camera 4")
                            btnchannel: 104
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/camera"
                        }
                        ListElement {
                            name: qsTr("Camera 5")
                            btnchannel: 105
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/camera"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property string iconUrl
                        width: (gridCamera.width + gridCamera.spacing)
                               / gridCamera.columns - gridCamera.spacing
                        height: (gridCamera.height + gridCamera.spacing)
                                / gridCamera.rows - gridCamera.spacing
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
                            btnchannel: 110
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
