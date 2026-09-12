/**
 * @file qml/pages/haishi/SingleScreen.qml
 * @brief 单画面页（海事大学）
 *
 * 左卡片"输出"：大屏/地插输出选择（D161~163）；
 * 右卡片"输入信号"：机柜电脑左右/摄像机/无线投屏/地插/一体机/VR 左右
 *   （D150~157），选中某输入即切换到当前输出。
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
            label: qsTr("输出")
            content: Grid {
                id: gridOutput
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listOutput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listOutput
                        ListElement {
                            name: qsTr("大屏")
                            btnchannel: 163
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/pingmugongxiang"
                        }
                        ListElement {
                            name: qsTr("地插输出")
                            btnchannel: 161
                            disBtnChannel: 0
                            iconUrl: "qrc:/icons/HDMIjiekou"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property string iconUrl
                        width: (gridOutput.width + gridOutput.spacing)
                               / gridOutput.columns - gridOutput.spacing
                        height: (gridOutput.height + gridOutput.spacing)
                                / gridOutput.rows - gridOutput.spacing
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
            Layout.maximumWidth: parent.width * 0.75
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("输入信号")
            content: Grid {
                id: gridInput
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(listInput.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: ListModel {
                        id: listInput
                        ListElement {
                            name: qsTr("机柜电脑-左")
                            btnchannel: 154
                            iconUrl: "qrc:/icons/zhuji"
                        }
                        ListElement {
                            name: qsTr("机柜电脑-右")
                            btnchannel: 157
                            iconUrl: "qrc:/icons/zhuji"
                        }
                        ListElement {
                            name: qsTr("摄像机")
                            btnchannel: 156
                            iconUrl: "qrc:/icons/camera"
                        }
                        ListElement {
                            name: qsTr("无线投屏")
                            btnchannel: 155
                            iconUrl: "qrc:/icons/wuxiantouping"
                        }
                        ListElement {
                            name: qsTr("地插-讲台")
                            btnchannel: 152
                            iconUrl: "qrc:/icons/HDMIjiekou"
                        }
                        ListElement {
                            name: qsTr("一体机")
                            btnchannel: 151
                            iconUrl: "qrc:/icons/yitiji"
                        }
                        ListElement {
                            name: qsTr("VR-左")
                            btnchannel: 153
                            iconUrl: "qrc:/icons/zhuji"
                        }
                        ListElement {
                            name: qsTr("VR-右")
                            btnchannel: 150
                            iconUrl: "qrc:/icons/zhuji"
                        }
                    }
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property string iconUrl
                        width: (gridInput.width + gridInput.spacing)
                               / gridInput.columns - gridInput.spacing
                        height: (gridInput.height + gridInput.spacing)
                                / gridInput.rows - gridInput.spacing
                        text: name
                        channel: btnchannel
                        source: iconUrl
                    }
                }
            }
        }
    }
}
