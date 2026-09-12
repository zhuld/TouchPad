/**
 * @file ShiyiMZ.qml
 * @brief 上海市第一人民医院门诊大楼指挥中心配置
 *
 * 页面列表：系统 / 视频 / 摄像机 / 音量 / 设备 / 灯光 / 测试（Pages/Shiyi/*）；
 *   disBtnChannel=4：系统反馈 D4 为真时除"系统"外的页签全部禁用（一键关闭场景）；
 * initValue：连接后预置的反馈初值（digital/digitalToggle/analog 各通道，
 *   digitalToggle 表示写入并取反的开关量初值）；
 * 系统页数据（CategoryType）：
 *   videoInput/videoOutput：视频输入/输出通道表（拖拽矩阵，
 *     inputChannel/outputChannel 为模拟量通道，btnChannel 为选中按钮，
 *     bgColor 决定拖拽/高亮颜色，disableOut 为互斥禁用输出）；
 *   volumeInput/volumeOutput：音频输入/输出音量条参数
 *     （vChannel 音量、mChannel 静音、minVol/maxVol 量程、inputType 输入/输出）；
 * tabOnBottom=false：页签栏在左侧（ContentColumn）。
 */

import QtQuick

QtObject {
    readonly property string logoName: qsTr("上海市第一人民医院")
    readonly property string titleName: qsTr("门诊大楼指挥中心会议室")
    readonly property string version: qsTr("202502")
    readonly property string background: "qrc:/images/shiyi.jpg"
    readonly property int processDialogChannel: 1
    readonly property string protocol: "CrestronCIP"

    //页面List
    readonly property ListModel pageList: ListModel {
        ListElement {
            name: qsTr("系统")
            pageUrl: "../Pages/Shiyi/System.qml"
            iconUrl: "qrc:/icons/home"
            test: false
            pageChannel: 11
            //disBtnChannel: 4
        }
        ListElement {
            name: qsTr("视频")
            pageUrl: "../Pages/Shiyi/Video.qml"
            iconUrl: "qrc:/icons/shipin"
            test: false
            pageChannel: 12
            disBtnChannel: 4
        }
        ListElement {
            name: qsTr("摄像机")
            pageUrl: "../Pages/Shiyi/CameraControl.qml"
            iconUrl: "qrc:/icons/shexiangtou"
            test: false
            pageChannel: 13
            disBtnChannel: 4
        }
        ListElement {
            name: qsTr("音量")
            pageUrl: "../Pages/Shiyi/Volume.qml"
            iconUrl: "qrc:/icons/music"
            test: false
            pageChannel: 14
            disBtnChannel: 4
        }
        ListElement {
            name: qsTr("设备")
            pageUrl: "../Pages/Shiyi/Power.qml"
            iconUrl: "qrc:/icons/jigui"
            test: false
            pageChannel: 15
            disBtnChannel: 4
        }
        ListElement {
            name: qsTr("灯光")
            pageUrl: "../Pages/Shiyi/Light.qml"
            iconUrl: "qrc:/icons/deng"
            test: true
            pageChannel: 16
            disBtnChannel: 4
        }
        ListElement {
            name: qsTr("测试")
            pageUrl: "../Pages/Test.qml"
            iconUrl: "qrc:/icons/test"
            test: true
            pageChannel: 18
            disBtnChannel: 4
        }
    }
    readonly property ListModel initValue: ListModel {
        ListElement {
            name: "digital"
            channel: 2
            value: 1
        }
        ListElement {
            name: "digitalToggle"
            channel: 46
            value: 1
        }
        ListElement {
            name: "digitalToggle"
            channel: 51
            value: 1
        }
        ListElement {
            name: "digitalToggle"
            channel: 52
            value: 1
        }
        ListElement {
            name: "digitalToggle"
            channel: 53
            value: 1
        }
        ListElement {
            name: "digitalToggle"
            channel: 54
            value: 1
        }
        ListElement {
            name: "digitalToggle"
            channel: 55
            value: 1
        }
        ListElement {
            name: "analog"
            channel: 11
            value: 54613
        }
        ListElement {
            name: "analog"
            channel: 12
            value: 54613
        }
        ListElement {
            name: "analog"
            channel: 13
            value: 54613
        }
        ListElement {
            name: "analog"
            channel: 14
            value: 54613
        }
        ListElement {
            name: "analog"
            channel: 15
            value: 57343
        }
    }
    readonly property bool tabOnBottom: false

    //灯光控制
    readonly property CategoryType light: CategoryType {
        label: qsTr("单独控制")
        backIcon: "qrc:/icons/deng"
        list: ListModel {
            ListElement {
                name: qsTr("左吸顶灯")
                btnChannel: 71
                iconUrlPressed: "qrc:/icons/deng"
                iconUrlReleased: "qrc:/icons/dengju"
            }
            ListElement {
                name: qsTr("右吸顶灯")
                btnChannel: 72
                iconUrlPressed: "qrc:/icons/deng"
                iconUrlReleased: "qrc:/icons/dengju"
            }
            ListElement {
                name: qsTr("前筒灯")
                btnChannel: 73
                iconUrlPressed: "qrc:/icons/deng"
                iconUrlReleased: "qrc:/icons/dengju"
            }
            ListElement {
                name: qsTr("四周筒灯")
                btnChannel: 74
                iconUrlPressed: "qrc:/icons/deng"
                iconUrlReleased: "qrc:/icons/dengju"
            }
            ListElement {
                name: qsTr("灯带")
                btnChannel: 75
                iconUrlPressed: "qrc:/icons/deng"
                iconUrlReleased: "qrc:/icons/dengju"
            }
            ListElement {
                name: qsTr("其他")
                btnChannel: 76
                iconUrlPressed: "qrc:/icons/deng"
                iconUrlReleased: "qrc:/icons/dengju"
            }
            ListElement {
                name: qsTr("壁灯")
                btnChannel: 77
                iconUrlPressed: "qrc:/icons/deng"
                iconUrlReleased: "qrc:/icons/dengju"
            }
        }
    }
    readonly property CategoryType lightMode: CategoryType {
        label: qsTr("灯光模式")
        backIcon: "qrc:/icons/config"
        list: ListModel {
            ListElement {
                name: qsTr("全开")
                btnchannel: 81
                iconUrl: "qrc:/icons/quankai"
            }
            ListElement {
                name: qsTr("全关")
                btnchannel: 82
                iconUrl: "qrc:/icons/quanguan"
            }
            ListElement {
                name: qsTr("会议")
                btnchannel: 83
                iconUrl: "qrc:/icons/huiyi"
            }
            ListElement {
                name: qsTr("节电")
                btnchannel: 84
                iconUrl: "qrc:/icons/jieneng"
            }
        }
    }
    //摄像头
    readonly property CategoryType position: CategoryType {
        label: qsTr("预置位")
        backIcon: "qrc:/icons/shexiangtou"
        channel: 46
        channelOn: qsTr("自动")
        channelOff: qsTr("手动")
        list: ListModel {
            ListElement {
                cameraRotation: 135
                btnchannel: 32
                label: "1"
                center: false
            }
            ListElement {
                cameraRotation: 45
                btnchannel: 33
                label: "2"
                center: false
            }
            ListElement {
                cameraRotation: 120
                btnchannel: 34
                label: "3"
                center: false
            }
            ListElement {
                cameraRotation: 60
                btnchannel: 35
                label: "4"
                center: false
            }
            ListElement {
                cameraRotation: 111
                btnchannel: 36
                label: "5"
                center: false
            }
            ListElement {
                cameraRotation: 69
                btnchannel: 37
                label: "6"
                center: false
            }
            ListElement {
                cameraRotation: 105
                btnchannel: 38
                disBtnChannel: 46
                label: "7"
                center: false
            }
            ListElement {
                cameraRotation: 75
                btnchannel: 39
                label: "8"
                center: false
            }
            ListElement {
                cameraRotation: 90
                btnchannel: 31
                label: "9"
                center: true
            }
        }
    }
    readonly property CategoryType cameraControl: CategoryType {
        label: qsTr("摄像机控制")
        backIcon: "qrc:/icons/shexiangtou"
        channel: 21
        // list: ListModel {
        //     ListElement {
        //         btnchannel: 27
        //         label: "前摄像头"
        //     }
        //     ListElement {
        //         btnchannel: 28
        //         label: "后摄像头"
        //     }
        //     ListElement {
        //         btnchannel: 29
        //         label: "右摄像头"
        //     }
        // }
    }
    //设备开关
    readonly property CategoryType powerTV: CategoryType {
        label: qsTr("显示屏幕")
        backIcon: "qrc:/icons/pingmugongxiang"
        list: ListModel {
            ListElement {
                name: qsTr("开机")
                btnchannel: 71
                iconUrl: "qrc:/icons/guanji"
            }
            ListElement {
                name: qsTr("关机")
                btnchannel: 72
                iconUrl: "qrc:/icons/guanji"
            }
            ListElement {
                name: qsTr("电脑")
                btnchannel: 73
                iconUrl: "qrc:/icons/hdmi"
            }
            ListElement {
                name: qsTr("Android")
                btnchannel: 74
                iconUrl: "qrc:/icons/android"
            }
        }
    }

    readonly property CategoryType powerCamera: CategoryType {
        label: qsTr("摄像机")
        backIcon: "qrc:/icons/shexiangtou"
        list: ListModel {
            ListElement {
                name: qsTr("开机")
                btnchannel: 75
                iconUrl: "qrc:/icons/guanji"
            }
            ListElement {
                name: qsTr("关机")
                btnchannel: 76
                iconUrl: "qrc:/icons/guanji"
            }
        }
    }
    //系统设置
    readonly property CategoryType system: CategoryType {
        label: qsTr("会议模式")
        backIcon: "qrc:/icons/config"
        list: ListModel {
            ListElement {
                name: qsTr("显示屏会议")
                btnchannel: 2
                disBtnChannel: 0
                sizeRatio: 1
                bColor: "mediumseagreen"
                iconUrl: "qrc:/icons/pingmugongxiang"
                showDialog: true
            }
            ListElement {
                name: qsTr("普通会议")
                btnchannel: 3
                disBtnChannel: 0
                sizeRatio: 1
                bColor: "mediumseagreen"
                iconUrl: "qrc:/icons/huiyi"
                showDialog: true
            }
            ListElement {
                name: qsTr("结束会议")
                btnchannel: 4
                disBtnChannel: 0
                sizeRatio: 1
                bColor: "salmon"
                iconUrl: "qrc:/icons/guanji"
                showDialog: true
            }
        }
    }

    readonly property CategoryType systemMode: CategoryType {
        label: qsTr("显示模式")
        backIcon: "qrc:/icons/shipinhuiyi"
        list: ListModel {
            ListElement {
                name: qsTr("华为视频会议")
                btnchannel: 61
                iconUrl: "qrc:/icons/shipinhuiyi"
                disBtnChannel: 4
            }
            ListElement {
                name: qsTr("远程视频会议")
                btnchannel: 62
                iconUrl: "qrc:/icons/shipinhuiyi"
                disBtnChannel: 4
            }
            ListElement {
                name: qsTr("内网电脑")
                btnchannel: 63
                iconUrl: "qrc:/icons/zhuji"
                disBtnChannel: 4
            }
            ListElement {
                name: qsTr("外网电脑")
                btnchannel: 64
                iconUrl: "qrc:/icons/zhuji"
                disBtnChannel: 4
            }
            ListElement {
                name: qsTr("无线投屏")
                btnchannel: 65
                iconUrl: "qrc:/icons/wuxiantouping"
                disBtnChannel: 4
            }
        }
    }
    //视频切换
    readonly property CategoryType vidoeOutput: CategoryType {
        label: qsTr("输出")
        backIcon: "qrc:/icons/shipin"
        list: ListModel {
            ListElement {
                name: qsTr("显示屏")
                outputChannel: 1
            }
            ListElement {
                name: qsTr("华为视频会议辅流")
                outputChannel: 2
            }
            ListElement {
                name: qsTr("远程视频会议内容")
                outputChannel: 3
            }
            ListElement {
                name: qsTr("预留输出")
                outputChannel: 4
            }
        }
    }
    readonly property CategoryType vidoeInput: CategoryType {
        label: qsTr("输入信号")
        backIcon: "qrc:/icons/shipin"
        info: qsTr("拖拽输入信号到输出")
        infoIcon: "qrc:/icons/tishi"
        list: ListModel {
            ListElement {
                name: qsTr("外网电脑")
                inputChannel: 1
                bgColor: "#4286f4"
                source: "qrc:/icons/zhuji"
                btnChannel: 91
                disableOut: 3
            }
            ListElement {
                name: qsTr("内网电脑")
                inputChannel: 2
                bgColor: "#f5af19"
                source: "qrc:/icons/zhuji"
                btnChannel: 92
            }
            ListElement {
                name: qsTr("华为视频会议")
                inputChannel: 3
                bgColor: "#96c93d"
                source: "qrc:/icons/shipinhuiyi"
                btnChannel: 93
                disableOut: 2
            }
            ListElement {
                name: qsTr("无线投屏")
                inputChannel: 4
                bgColor: "#f953c6"
                source: "qrc:/icons/wuxiantouping"
                btnChannel: 94
            }
            ListElement {
                name: qsTr("摄像机")
                inputChannel: 5
                bgColor: "#ff4b2b"
                source: "qrc:/icons/shexiangtou"
                btnChannel: 95
                disableOut: 2
            }
            ListElement {
                name: qsTr("预留输入")
                inputChannel: 6
                bgColor: "#6dd5ed" //"cadetblue"
                source: "qrc:/icons/HDMIjiekou"
                btnChannel: 96
                //disableOut: 4
            }
        }
    }
    //音频
    readonly property CategoryType volumeInput: CategoryType {
        label: qsTr("音频输入")
        backIcon: "qrc:/icons/music"
        list: ListModel {
            ListElement {
                name: qsTr("鹅颈话筒")
                vChannel: 11
                vLevel: 0
                mChannel: 51
                minVol: -30
                maxVol: 0
                inputType: true
            }
            ListElement {
                name: qsTr("手持话筒")
                vChannel: 12
                vLevel: 0
                mChannel: 52
                minVol: -30
                maxVol: 0
                inputType: true
            }
            ListElement {
                name: qsTr("电脑音频")
                vChannel: 13
                vLevel: 0
                mChannel: 53
                minVol: -30
                maxVol: 0
                inputType: true
            }
        }
    }
    readonly property CategoryType volumeOutput: CategoryType {
        label: qsTr("总音频输出")
        backIcon: "qrc:/icons/music"
        list: ListModel {
            ListElement {
                name: qsTr("")
                vChannel: 15
                vLevel: 0
                mChannel: 55
                minVol: -40
                maxVol: 5
                inputType: false
            }
        }
    }
}
