/**
 * @file ContentRow.qml
 * @brief 主内容区（页签栏在底部的布局，tabOnBottom=true 的配置使用）
 *
 * 结构与 ContentColumn 一致：底部横排页签栏（超宽时可横向滚动）+
 * 上方 StackLayout 按需加载各页面；页签同样从配置 pageList 过滤生成，
 * test=true 的测试页仅在 showChannel 调试模式下加入；
 * ProcessDialog：命令执行中的等待弹窗。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import "../Dialog"

Item {
    id: main
    anchors.fill: parent
    anchors.bottomMargin: width * 0.02

    property ListModel tabList: ListModel {} //tab页面

    ProcessDialog {
        id: processDialog
        dialogInfomation: "正在执行指令，请稍后..."
        dialogTitle: "提示"
        channel: Global.configList[Global.settings.configSetting].processDialogChannel
        autoClose: 50
    }
    ListView {
        id: tabBar
        width: parent.width * 0.96 > (height * 0.85 + spacing) * main.tabList.count ? (height * 0.85 + spacing) * main.tabList.count : parent.width * 0.96
        height: parent.height * 0.16
        clip: true
        spacing: height * 0.2
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: ListView.Horizontal
        interactive: parent.width * 0.96 > (height * 0.85 + spacing) * main.tabList.count ? false : true
        model: main.tabList
        delegate: MyTabButton {
            id: tabButton
            required property string name
            required property string iconUrl
            required property int index
            required property int pageChannel
            required property int disBtnChannel
            disableChannel: disBtnChannel
            text: name
            width: height
            height: tabBar.height * 0.85
            source: iconUrl
            channel: pageChannel
            onCheckedChanged: {
                if (checked & stackLayout.currentIndex !== index) {
                    stackLayout.currentIndex = index;
                }
            }
        }
    }
    StackLayout {
        id: stackLayout
        anchors.top: parent.top
        width: parent.width * 0.98
        height: parent.height - tabBar.height
        anchors.right: parent.right
        Repeater {
            model: main.tabList
            delegate: Loader {
                id: pageLoader
                required property string pageUrl
                source: pageUrl
            }
        }
        clip: true
    }
    Component.onCompleted: {
        // Clear the filtered model
        main.tabList.clear();
        for (var i = 0; i < Global.configList[Global.settings.configSetting].pageList.count; i++) {
            let item = Global.configList[Global.settings.configSetting].pageList.get(i);
            if (!item.test || Global.settings.showChannel) {
                main.tabList.append(item);
            }
        }
    }
}
