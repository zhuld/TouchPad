/**
 * @file Shiyi/System.qml
 * @brief 系统页（第一人民医院：常用开关 + 场景模式）
 *
 * 左卡片"系统"：MyButton 按钮网格（数据取 ShiyiMZ.system，
 *   btnchannel 通道、showDialog 为真时弹确认框、bColor 定制选中色）；
 * 右卡片"模式"：VButton 图标按钮网格（数据取 ShiyiMZ.systemMode）。
 * 各按钮的禁用联动由全局反馈（disBtnChannel）驱动。
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
            id: systemCategory
            property CategoryType system: Global.configList[Global.shiyiMZ].system
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: system.label
            backIcon: system.backIcon
            content: Grid {
                id: gridSystem
                rows: 4
                anchors.fill: parent
                columns: Math.ceil(systemCategory.system.list.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: systemCategory.system.list
                    delegate: MyButton {
                        required property string name
                        required property int btnchannel
                        required property int disBtnChannel
                        required property real sizeRatio
                        required property string iconUrl
                        required property bool showDialog
                        required property color bColor
                        width: (gridSystem.width + gridSystem.spacing)
                               / gridSystem.columns - gridSystem.spacing
                        height: (gridSystem.height + gridSystem.spacing)
                                / gridSystem.rows - gridSystem.spacing
                        text: name
                        channel: btnchannel
                        disableChannel: disBtnChannel
                        source: iconUrl
                        confirm: showDialog
                        btnCheckColor: Qt.darker(bColor, 1.4)
                    }
                }
            }
        }

        Category {
            id: systemModeCategory
            property CategoryType systemMode: Global.configList[Global.shiyiMZ].systemMode
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: systemMode.label
            backIcon: systemMode.backIcon
            content: Grid {
                id: gridMode
                rows: 3
                anchors.fill: parent
                columns: Math.ceil(
                             systemModeCategory.systemMode.list.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: systemModeCategory.systemMode.list
                    delegate: VButton {
                        required property string name
                        required property int btnchannel
                        required property string iconUrl
                        required property int disBtnChannel
                        disableChannel: disBtnChannel
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
