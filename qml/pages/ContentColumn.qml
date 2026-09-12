/**
 * @file qml/pages/ContentColumn.qml
 * @brief 主内容区（页签栏在左侧的布局，tabOnBottom=false 的配置使用）
 *
 * 结构：左侧竖排页签栏（MyTabButton 列表，选中态由中控反馈 pageChannel 驱动，
 *   勾选时切换 StackLayout 对应页）+ 右侧 StackLayout 按需异步加载各页面；
 * 页签来源：当前配置的 pageList，test=true 的测试页仅在 showChannel 调试模式下加入；
 * ProcessDialog：命令执行中的等待弹窗（通道取自配置的 processDialogChannel）。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import "../dialog"

Item {
    id: main
    anchors.fill: parent
    anchors.leftMargin: width * 0.02

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
        width: parent.width * 0.11
        height: parent.height * 0.98 > (width * 0.8 + spacing) * main.tabList.count ? (width * 0.8 + spacing) * main.tabList.count : parent.height * 0.98
        clip: true
        spacing: width * 0.2
        anchors.top: parent.top
        interactive: parent.height * 0.98 > (width * 0.8 + spacing) * main.tabList.count ? false : true
        leftMargin: width * 0.05
        topMargin: width * 0.05
        bottomMargin: width * 0.1
        model: main.tabList
        delegate: MyTabButton {
            required property string name
            required property string iconUrl
            required property int index
            required property int pageChannel
            required property string pageUrl
            required property int disBtnChannel
            disableChannel: disBtnChannel
            text: name
            width: tabBar.width * 0.8
            height: width
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
        anchors.right: parent.right
        width: parent.width - tabBar.width
        height: parent.height
        Repeater {
            model: main.tabList
            delegate: Loader {
                id: pageLoader
                required property string pageUrl
                source: pageUrl
                asynchronous: true
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
