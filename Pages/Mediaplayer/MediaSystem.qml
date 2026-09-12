/**
 * @file Mediaplayer/MediaSystem.qml
 * @brief 系统控制页（媒体播放器）
 *
 * 左卡片"运行程序"：Edge/记事本打开与关闭（D74~77）；
 * 右卡片"系统控制"：桌面显示/停止播放（D71~72）、
 *   重启（D73）/关机（D500）——后两者 confirm=true，弹确认框防误触。
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
            label: qsTr("运行程序")
            content: Grid {
                id: gridExe
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listOutput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listOutput
                        ListElement {
                            name: qsTr("Edge打开")
                            btnchannel: 74
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/yunxinruanjian"
                        }
                        ListElement {
                            name: qsTr("记事本打开")
                            btnchannel: 75
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/yunxinruanjian"
                        }
                        ListElement {
                            name: qsTr("Edge关闭")
                            btnchannel: 76
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/guanbiruanjian"
                        }
                        ListElement {
                            name: qsTr("记事本关闭")
                            btnchannel: 77
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/guanbiruanjian"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property string iconUrl
                        width: (gridExe.width + gridExe.spacing) / gridExe.columns - gridExe.spacing
                        height: (gridExe.height + gridExe.spacing) / gridExe.rows - gridExe.spacing
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
            label: qsTr("系统控制")
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
                            name: qsTr("桌面显示")
                            btnchannel: 71
                            iconUrl: "qrc:/icons/yitiji"
                        }
                        ListElement {
                            name: qsTr("停止播放")
                            btnchannel: 72
                            iconUrl: "qrc:/icons/tingzhibofang"
                        }
                        ListElement {
                            name: qsTr("重启")
                            btnchannel: 73
                            iconUrl: "qrc:/icons/chongqi"
                            showDialog: true
                        }
                        ListElement {
                            name: qsTr("关机")
                            btnchannel: 500
                            iconUrl: "qrc:/icons/guanji"
                            showDialog: true
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property string iconUrl
                        required property bool showDialog
                        width: (gridControl.width + gridControl.spacing)
                               / gridControl.columns - gridControl.spacing
                        height: (gridControl.height + gridControl.spacing)
                                / gridControl.rows - gridControl.spacing
                        text: name
                        channel: btnchannel
                        source: iconUrl
                        confirm: showDialog
                    }
                }
            }
        }
    }
}
