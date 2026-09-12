/**
 * @file Shiyi/Volume.qml
 * @brief 音量控制页
 *
 * 左卡片"音频输入"：鹅颈话筒/手持话筒/电脑音频三条 VolumeBar
 *   （数据取 ShiyiMZ.volumeInput：vChannel 音量、mChannel 静音、量程）；
 * 右卡片"总音频输出"：总输出音量条（ShiyiMZ.volumeOutput）。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Item {
    implicitWidth: parent.width
    implicitHeight: parent.height
    RowLayout {
        id: volList
        anchors.fill: parent
        Category {
            id: volumeInputCategory
            property CategoryType volumeInput: Global.configList[Global.shiyiMZ].volumeInput
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.75
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: volumeInput.label
            backIcon: volumeInput.backIcon
            content: Grid {
                id: gridInput
                rows: 1
                anchors.fill: parent
                columns: volumeInputCategory.volumeInput.list.count
                spacing: height * 0.05
                Repeater {
                    model: volumeInputCategory.volumeInput.list
                    delegate: VolumeBar {
                        required property string name
                        required property int vChannel
                        required property int vLevel
                        required property int mChannel
                        required property int minVol
                        required property int maxVol
                        required property bool inputType
                        label: name
                        width: (gridInput.width + gridInput.spacing)
                               / gridInput.columns - gridInput.spacing
                        height: gridInput.height
                        channel: vChannel
                        muteChannel: mChannel
                        miniVolume: minVol
                        maxVolume: maxVol
                        input: inputType
                        level: vLevel
                    }
                }
            }
        }

        Category {
            id: volumeOutputCategory
            property CategoryType volumeOutput: Global.configList[Global.shiyiMZ].volumeOutput
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.25
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: volumeOutput.label
            backIcon: volumeOutput.backIcon
            content: Grid {
                id: gridOutput
                rows: 1
                anchors.fill: parent
                columns: volumeOutputCategory.volumeOutput.list.count
                spacing: height * 0.05
                Repeater {
                    model: volumeOutputCategory.volumeOutput.list
                    delegate: VolumeBar {
                        required property string name
                        required property int vChannel
                        required property int vLevel
                        required property int mChannel
                        required property int minVol
                        required property int maxVol
                        required property bool inputType
                        label: name
                        width: (gridOutput.width + gridOutput.spacing)
                               / gridOutput.columns - gridOutput.spacing
                        height: gridOutput.height
                        channel: vChannel
                        muteChannel: mChannel
                        miniVolume: minVol
                        maxVolume: maxVol
                        input: inputType
                        level: vLevel
                    }
                }
            }
        }
    }
}
