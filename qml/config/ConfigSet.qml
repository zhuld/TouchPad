/**
 * @file ConfigSet.qml
 * @brief 启动页配置（configSetting = 0 时使用）
 *
 * 仅提供标题/版本/背景等元信息；pageList 为空，
 * 使 Main.qml 的 Loader 进入"配置文件选择"页（Pages/ConfigSelect.qml）。
 * processDialogChannel：启动页占用的过程等待对话框通道。
 */

import QtQuick

QtObject {
    readonly property string logoName: qsTr("启动页面")
    readonly property string titleName: qsTr("配置文件选择")
    readonly property string version: qsTr("202501")
    readonly property string background: "qrc:/images/background.jpg"
    // 说明：logoImage 属性从未被任何页面引用，属于死代码，已删除。
    readonly property int processDialogChannel: 0

    readonly property ListModel pageList: ListModel {}

    readonly property ListModel initValue: ListModel {}

    readonly property bool tabOnBottom: false
}
