/**
 * @file qml/config/MediaPlayer.qml
 * @brief 媒体播放器配置
 *
 * 页面列表：视频 / 背景音乐 / PPT / Flash / 图片 / 摄像头 / 网页 / 系统
 *   （pages/mediaplayer/*），页签通道 pageChannel 为 11~18；
 * initValue：连接后预置的反馈初值（模拟量通道 1 = 19661）；
 * tabOnBottom=true：页签栏在底部（ContentRow）。
 */

import QtQuick

QtObject {
    readonly property string logoName: qsTr("媒体播放器")
    readonly property string titleName: qsTr("控制面板")
    readonly property string version: qsTr("202508")
    readonly property string background: "qrc:/images/mediaplayer.jpg"
    readonly property int processDialogChannel: 1
    readonly property string protocol: "CrestronCIP"

    //页面List
    readonly property ListModel pageList: ListModel {
        ListElement {
            name: qsTr("视频")
            pageUrl: "../pages/mediaplayer/Movie.qml"
            iconUrl: "qrc:/icons/shipin"
            test: false
            pageChannel: 11
            disBtnChannel: 0
        }
        ListElement {
            name: qsTr("背景音乐")
            pageUrl: "../pages/mediaplayer/Sound.qml"
            iconUrl: "qrc:/icons/music"
            test: false
            pageChannel: 12
        }
        ListElement {
            name: qsTr("PPT")
            pageUrl: "../pages/mediaplayer/PPT.qml"
            iconUrl: "qrc:/icons/ppt"
            test: false
            pageChannel: 13
        }
        ListElement {
            name: qsTr("Flash")
            pageUrl: "../pages/mediaplayer/Flash.qml"
            iconUrl: "qrc:/icons/flash"
            test: false
            pageChannel: 14
        }
        ListElement {
            name: qsTr("图片")
            pageUrl: "../pages/mediaplayer/Picture.qml"
            iconUrl: "qrc:/icons/tupianji"
            test: false
            pageChannel: 15
        }
        ListElement {
            name: qsTr("摄像头")
            pageUrl: "../pages/mediaplayer/MediaCamera.qml"
            iconUrl: "qrc:/icons/camera"
            test: false
            pageChannel: 16
        }
        ListElement {
            name: qsTr("网页")
            pageUrl: "../pages/mediaplayer/Web.qml"
            iconUrl: "qrc:/icons/web"
            test: false
            pageChannel: 17
        }
        ListElement {
            name: qsTr("系统")
            pageUrl: "../pages/mediaplayer/MediaSystem.qml"
            iconUrl: "qrc:/icons/config"
            test: false
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
    readonly property bool tabOnBottom: true
}
