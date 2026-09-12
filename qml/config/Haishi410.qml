/**
 * @file qml/config/Haishi410.qml
 * @brief 海事大学 410 沉浸式教室配置
 *
 * 页面列表：远程 / 单画面 / VR / LED屏 / 摄像机 / 测试（pages/haishi/*）；
 *   每项含页签通道 pageChannel、图标与可选的禁用通道 disBtnChannel，
 *   test=true 的页签仅调试时显示；
 * initValue：连接后预置的反馈初值（模拟量通道 1 = 19661）；
 * tabOnBottom=false：页签栏在左侧（ContentColumn）。
 */

import QtQuick

QtObject {
    readonly property string logoName: qsTr("海事大学")
    readonly property string titleName: qsTr("410沉浸式教室")
    readonly property string version: qsTr("202411")
    readonly property string background: "qrc:/images/haishi.jpg"
    readonly property int processDialogChannel: 1
    readonly property string protocol: "CrestronCIP"

    //页面List
    readonly property ListModel pageList: ListModel {
        ListElement {
            name: qsTr("远程")
            pageUrl: "../pages/haishi/Remote.qml"
            iconUrl: "qrc:/icons/shipinhuiyi"
            test: false
            pageChannel: 16
            disBtnChannel: 0
        }
        ListElement {
            name: qsTr("单画面")
            pageUrl: "../pages/haishi/SingleScreen.qml"
            iconUrl: "qrc:/icons/danhuamian"
            test: false
            pageChannel: 12
        }
        ListElement {
            name: qsTr("VR")
            pageUrl: "../pages/haishi/VR.qml"
            iconUrl: "qrc:/icons/vr"
            test: false
            pageChannel: 13
        }
        ListElement {
            name: qsTr("LED屏")
            pageUrl: "../pages/haishi/LED.qml"
            iconUrl: "qrc:/icons/led"
            test: false
            pageChannel: 14
        }
        ListElement {
            name: qsTr("摄像机")
            pageUrl: "../pages/haishi/Camera.qml"
            iconUrl: "qrc:/icons/camera"
            test: false
            pageChannel: 15
        }

        ListElement {
            name: qsTr("测试")
            pageUrl: "../pages/Test.qml"
            iconUrl: "qrc:/icons/test"
            test: true
            pageChannel: 18
        }
    }
    readonly property ListModel initValue: ListModel {
        ListElement {
            name: "analog"
            channel: 1
            value: 19661
        }
    }
    readonly property bool tabOnBottom: false
}
