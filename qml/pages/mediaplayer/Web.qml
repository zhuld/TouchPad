/**
 * @file Mediaplayer/Web.qml
 * @brief 网页展示页（媒体播放器）
 *
 * 左卡片"网页"：Baidu/Bing/Action/Clock 页面选择（D81~84）；
 * 右卡片"控制"：停止（D86）。
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
            label: qsTr("网页")
            content: Grid {
                id: gridWeb
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listOutput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listOutput
                        ListElement {
                            name: qsTr("Baidu")
                            btnchannel: 81
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/web"
                        }
                        ListElement {
                            name: qsTr("Bing")
                            btnchannel: 82
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/web"
                        }
                        ListElement {
                            name: qsTr("Action")
                            btnchannel: 83
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/web"
                        }
                        ListElement {
                            name: qsTr("Clock")
                            btnchannel: 84
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/web"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property string iconUrl
                        width: (gridWeb.width + gridWeb.spacing) / gridWeb.columns - gridWeb.spacing
                        height: (gridWeb.height + gridWeb.spacing) / gridWeb.rows - gridWeb.spacing
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
                            btnchannel: 86
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
