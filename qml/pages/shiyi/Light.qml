/**
 * @file qml/pages/shiyi/Light.qml
 * @brief 灯光控制页（test=true 页签，仅调试模式显示）
 *
 * 左卡片（ShiyiMZ.light）：分组灯光开关（VButton），
 *   图标随选中状态切换（iconUrlPressed/iconUrlReleased）；
 * 右卡片（ShiyiMZ.lightMode）：灯光情景模式按钮（MyButton，单列）。
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
            id: lightCategory
            property CategoryType light: Global.configList[Global.shiyiMZ].light
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: light.label
            backIcon: light.backIcon
            content: Grid {
                id: gridLight
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(lightCategory.light.list.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: lightCategory.light.list
                    delegate: VButton {
                        required property int btnChannel
                        required property string name
                        required property string iconUrlPressed
                        required property string iconUrlReleased
                        text: name
                        channel: btnChannel
                        width: (gridLight.width + gridLight.spacing)
                               / gridLight.columns - gridLight.spacing
                        height: (gridLight.height + gridLight.spacing)
                                / gridLight.rows - gridLight.spacing
                        source: checked ? iconUrlPressed : iconUrlReleased
                    }
                }
            }
        }
        Category {
            id: lightModeCategory
            property CategoryType lightMode: Global.configList[Global.shiyiMZ].lightMode
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: lightMode.label
            backIcon: lightMode.backIcon
            content: Grid {
                id: gridMode
                rows: lightModeCategory.lightMode.list.count
                anchors.fill: parent
                columns: 1
                spacing: height * 0.05
                Repeater {
                    model: lightModeCategory.lightMode.list
                    delegate: MyButton {
                        required property string name
                        required property int btnchannel
                        required property string iconUrl
                        width: (gridMode.width + gridMode.spacing)
                               / gridMode.columns - gridMode.spacing
                        height: (gridMode.height + gridMode.spacing)
                                / gridMode.rows - gridMode.spacing
                        text: name
                        channel: btnchannel
                        source: iconUrl
                    }
                }
            }
        }
    }
}
