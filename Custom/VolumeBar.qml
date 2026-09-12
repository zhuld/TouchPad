/**
 * @file VolumeBar.qml
 * @brief 音量条组件（垂直滑块 + 刻度 + 静音按钮）
 *
 * 结构：label 标题、垂直 Slider（背景为绿→橙→红渐变条，
 *       左右两侧刻度，>=0dB 的高音区刻度用警示色）、
 *       静音按钮（复用 MyButton，channel=muteChannel）、数值标签。
 * 数据：value 由 Global.analog[channel]（0~65535）映射到
 *       miniVolume~maxVolume（默认 -40~0 dB）；stepSize=1。
 * 交互：live=false + 200ms 防抖 Timer，滑动停止后发送
 *       CrestronCIP.level(channel, 0~65535 模拟量)。
 * 调试：showChannel 打开时显示 "A+channel E+disableChannel"。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Controls.Fusion

import "../Js/crestroncip.js" as CrestronCIP

Item {
    id: controlVolumeBar
    implicitHeight: parent.height
    implicitWidth: parent.width

    property int miniVolume: -40
    property int maxVolume: 0

    property int muteChannel
    property int channel
    property int level
    property int disableChannel: 0

    property bool input: true

    property bool muteBtn: true
    property string label: ""

    enabled: Global.digital[controlVolumeBar.disableChannel] ? false : true
    opacity: enabled ? 1 : Global.disableOpacity

    Column {
        anchors.fill: parent
        clip: true
        spacing: height * 0.02
        MyIconLabel {
            id: label
            height: controlVolumeBar.label === "" ? 0 : parent.height * 0.05
            width: parent.width
            text: controlVolumeBar.label
            font.pixelSize: height
        }
        Slider {
            id: slider
            height: controlVolumeBar.label === "" ? parent.height * 0.85 : parent.height * 0.78
            width: parent.width * 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            orientation: Qt.Vertical
            live: false
            value: Math.round(Global.analog[controlVolumeBar.channel] * (controlVolumeBar.maxVolume - controlVolumeBar.miniVolume) / 65535 + controlVolumeBar.miniVolume)
            from: controlVolumeBar.miniVolume
            to: controlVolumeBar.maxVolume
            stepSize: 1

            snapMode: Slider.SnapAlways

            background: Shape {
                id: back
                height: parent.height - handle.height + width
                width: parent.width * 0.05
                y: handle.height / 2 - width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                ShapePath {
                    strokeWidth: 0
                    strokeColor: "transparent"
                    PathRectangle {
                        id: pathRect
                        x: 0
                        y: 0
                        radius: width * 0.3
                        width: back.width
                        height: back.height
                    }
                    fillGradient: LinearGradient {
                        y1: pathRect.height
                        y2: 0
                        x1: pathRect.width / 2
                        x2: pathRect.width / 2
                        GradientStop {
                            position: 0.6
                            color: "green"
                        }
                        GradientStop {
                            position: 0.8
                            color: "orange"
                        }
                        GradientStop {
                            position: 1
                            color: "red"
                        }
                    }
                }
                ShapePath {
                    strokeWidth: 0
                    strokeColor: "transparent"
                    PathRectangle {
                        id: pathRectangle
                        x: 0
                        y: 0
                        radius: width * 0.3
                        width: back.width
                        height: slider.visualPosition * back.height
                    }
                    fillGradient: LinearGradient {
                        y1: pathRectangle.height / 2
                        y2: pathRectangle.height / 2
                        x1: 0
                        x2: pathRectangle.width
                        GradientStop {
                            position: 0
                            color: Qt.darker(Global.buttonColor, 1.4)
                        }
                        GradientStop {
                            position: 1
                            color: Global.buttonColor
                        }
                    }
                }
            }

            handle: Rectangle {
                id: handle
                width: parent.width * 0.3
                height: width * 2
                anchors.horizontalCenter: parent.horizontalCenter
                y: slider.visualPosition * (parent.height - height)
                Behavior on y {
                    enabled: !slider.pressed
                    NumberAnimation {
                        duration: Global.durationDelay
                    }
                }
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: controlVolumeBar.input ? "#07111B" : "#57111B"
                    }
                    GradientStop {
                        position: 0.1
                        color: controlVolumeBar.input ? "#5598CF" : "#A598CF"
                    }
                    GradientStop {
                        position: 0.2
                        color: controlVolumeBar.input ? "#182632" : "#682632"
                    }
                    GradientStop {
                        position: 0.48
                        color: controlVolumeBar.input ? "#2F4E69" : "#8F4E69"
                    }
                    GradientStop {
                        position: 0.50
                        color: controlVolumeBar.input ? "#A8C8E8" : "#A8C8E8"
                    }
                    GradientStop {
                        position: 0.52
                        color: controlVolumeBar.input ? "#385E7E" : "#885E7E"
                    }
                    GradientStop {
                        position: 0.9
                        color: controlVolumeBar.input ? "#3F6C94" : "#8F6C94"
                    }
                    GradientStop {
                        position: 1.0
                        color: controlVolumeBar.input ? "#07111B" : "#57111B"
                    }
                }
                radius: width * 0.1
                layer.enabled: Global.settings.shadow
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: Global.buttonShadowColor
                    shadowHorizontalOffset: slider.pressed ? Global.shadowHeight / 2 : Global.shadowHeight
                    shadowVerticalOffset: shadowHorizontalOffset * (1 - slider.position)
                    Behavior on shadowHorizontalOffset {
                        NumberAnimation {
                            duration: Global.durationDelay
                        }
                    }
                }
            }

            contentItem: Repeater {
                model: (controlVolumeBar.maxVolume - controlVolumeBar.miniVolume) + 1
                delegate: Item {
                    id: item
                    required property int index
                    anchors.fill: parent
                    Shape {
                        //刻度线左
                        ShapePath {
                            strokeColor: (controlVolumeBar.maxVolume - item.index) <= 0 ? Global.buttonTextColor : Global.buttonWarnColor
                            strokeWidth: item.index % 5 === 0 ? 3 : 1
                            startX: item.index % 5 === 0 ? slider.width * 0.1 : slider.width * 0.3
                            startY: slider.handle.height / 2 + (slider.height - slider.handle.height) / (controlVolumeBar.maxVolume - controlVolumeBar.miniVolume) * item.index
                            PathLine {
                                x: slider.width * 0.4
                                y: slider.handle.height / 2 + (slider.height - slider.handle.height) / (controlVolumeBar.maxVolume - controlVolumeBar.miniVolume) * item.index
                            }
                        }
                        //刻度线右
                        ShapePath {
                            strokeColor: (controlVolumeBar.maxVolume - item.index) <= 0 ? Global.buttonTextColor : Global.buttonWarnColor
                            strokeWidth: item.index % 5 === 0 ? 3 : 1
                            startX: slider.width * 0.6
                            startY: slider.handle.height / 2 + (slider.height - slider.handle.height) / (controlVolumeBar.maxVolume - controlVolumeBar.miniVolume) * item.index
                            PathLine {
                                x: item.index % 5 === 0 ? slider.width * 0.9 : slider.width * 0.7
                                y: slider.handle.height / 2 + (slider.height - slider.handle.height) / (controlVolumeBar.maxVolume - controlVolumeBar.miniVolume) * item.index
                            }
                        }
                    }

                    Text {
                        text: item.index % 5 === 0 ? controlVolumeBar.maxVolume - item.index : ""
                        width: parent.width * 0.3
                        height: slider.handle.height
                        horizontalAlignment: Text.AlignRight
                        x: -width * 0.2
                        y: (slider.height - height) / (controlVolumeBar.maxVolume - controlVolumeBar.miniVolume) * item.index - height * 0.2
                        color: (controlVolumeBar.maxVolume - item.index * 5) <= 0 ? Global.buttonTextColor : Global.buttonWarnColor
                        font.pixelSize: height * 0.25
                        verticalAlignment: Text.AlignVCenter
                        font.family: Global.alibabaPuHuiTi.font.family
                    }
                }
            }

            onMoved: {
                moveTimer.restart();
            }
            //用于检测滑块停止滑动
            Timer {
                id: moveTimer
                interval: 200 // 毫秒
                repeat: false
                onTriggered: {
                    CrestronCIP.level(controlVolumeBar.channel, Math.round(slider.position * 65535));
                }
            }
        }

        MyButton {
            height: parent.height * 0.1
            width: parent.width * 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            source: checked ? "qrc:/icons/mute" : "qrc:/icons/unmute"
            iconColor: checked ? Global.buttonWarnColor : Global.buttonTextColor
            channel: controlVolumeBar.muteChannel
            disableChannel: controlVolumeBar.disableChannel
            text: slider.value + "dB"
            visible: controlVolumeBar.muteBtn
        }
        MyIconLabel {
            height: parent.height * 0.1
            width: parent.width
            text: slider.value
            color: Global.buttonTextColor
            font.pixelSize: Global.channelSize
            font.family: Global.alibabaPuHuiTi.font.family
        }
    }
    Text {
        id: channel
        height: parent.height
        text: Global.settings.showChannel ? "A" + controlVolumeBar.channel + "E" + controlVolumeBar.disableChannel : ""
        color: Global.buttonTextColor
        font.pixelSize: Global.channelSize
        font.family: Global.alibabaPuHuiTi.font.family
    }
}
