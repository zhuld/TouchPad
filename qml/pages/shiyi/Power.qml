/**
 * @file qml/pages/shiyi/Power.qml
 * @brief 设备电源页
 *
 * 左卡片（ShiyiMZ.powerTV）：显示设备电源按钮网格（VButton）；
 * 右卡片（ShiyiMZ.powerCamera）：摄像机等外围设备电源按钮网格（VButton）。
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
            id: powerTVCategory
            property CategoryType powerTV: Global.configList[Global.shiyiMZ].powerTV
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.6
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: powerTV.label
            backIcon: powerTV.backIcon
            content: Grid {
                id: gridTV
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(powerTVCategory.powerTV.list.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: powerTVCategory.powerTV.list
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property string iconUrl
                        width: (gridTV.width + gridTV.spacing) / gridTV.columns - gridTV.spacing
                        height: (gridTV.height + gridTV.spacing) / gridTV.rows - gridTV.spacing
                        text: name
                        channel: btnchannel
                        source: iconUrl
                    }
                }
            }
        }
        Category {
            id: powerCameraCategory
            property CategoryType powerCamera: Global.configList[Global.shiyiMZ].powerCamera
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.4
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: powerCamera.label
            backIcon: powerCamera.backIcon
            content: Grid {
                id: gridCamera
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(
                             powerCameraCategory.powerCamera.list.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: powerCameraCategory.powerCamera.list
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property string iconUrl
                        width: (gridCamera.width + gridCamera.spacing)
                               / gridCamera.columns - gridCamera.spacing
                        height: (gridCamera.height + gridCamera.spacing)
                                / gridCamera.rows - gridCamera.spacing
                        text: name
                        channel: btnchannel
                        source: iconUrl
                    }
                }
            }
        }
    }
}
