/**
 * @file Output.qml
 * @brief 输出通道卡片（信号切换的目标端）
 *
 * 显示 output 通道当前接入的输入源：颜色/图标/名称取自
 * inputListMode 中第 input 项（Global.analog[output] 为当前输入号）；
 * 同时是 DropArea：接收 InputButton 拖放，drop 时调用
 * CrestronCIP.level(output, input) 向中控发送切换命令，
 * 拖入时阴影变为拖拽源按钮的颜色（dragShadowColor）作为提示；
 * pressLock：页面在按住互斥输入按钮时经绑定置 true，临时禁用本卡。
 * 调试：showChannel 打开时显示 "A+output E+disableChannel"。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import "../Js/crestroncip.js" as CrestronCIP

Item {
    id: controlOutput

    property int output
    property alias textOutput: textOutput.text
    property color dragShadowColor
    readonly property int input: Global.analog[output]
    property int disableChannel: 0
    /// 按住互斥输入按钮时的临时锁定标志（由页面绑定传入，true 时本卡禁用变暗）
    property bool pressLock: false
    property ListModel inputListMode

    enabled: !pressLock && (Global.digital[controlOutput.disableChannel] ? false : true)
    opacity: enabled ? 1 : Global.disableOpacity / 2
    layer.enabled: true
    layer.effect: MultiEffect {
        id: effect
        shadowEnabled: true
        shadowColor: dropContainer.containsDrag ? controlOutput.dragShadowColor : Global.buttonShadowColor
        shadowHorizontalOffset: Global.shadowHeight
        shadowVerticalOffset: Global.shadowHeight
        Behavior on shadowColor {
            ColorAnimation {
                duration: Global.durationDelay
            }
        }
    }
    Shape {
        id: back
        anchors.fill: parent
        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            PathRectangle {
                x: 0
                y: 0
                width: back.width
                height: back.height
                radius: height / 5
            }
            fillGradient: RadialGradient {
                centerX: back.width * 0.5
                centerY: back.height * 0.5
                centerRadius: Math.max(back.width, back.height)
                focalX: back.width * 0.5
                focalY: back.height
                GradientStop {
                    position: 1
                    color: controlOutput.input > 0 & controlOutput.input <= controlOutput.inputListMode.count ? Qt.darker(controlOutput.inputListMode.get(controlOutput.input - 1).bgColor, 1.5) : Global.backgroundColor
                    Behavior on color {
                        ColorAnimation {
                            duration: Global.durationDelay
                        }
                    }
                }
                GradientStop {
                    position: 0
                    color: controlOutput.input > 0 & controlOutput.input <= controlOutput.inputListMode.count ? controlOutput.inputListMode.get(controlOutput.input - 1).bgColor : Global.backgroundColor
                    Behavior on color {
                        ColorAnimation {
                            duration: Global.durationDelay
                        }
                    }
                }
            }
        }
    }

    Text {
        id: textOutput
        height: parent.height * 0.5
        font.pixelSize: height * 0.5
        x: outputNumber.width / 4
        verticalAlignment: Text.AlignVCenter
        text: "Output"
        color: Global.buttonTextColor
        font.family: Global.alibabaPuHuiTi.font.family
    }

    Text {
        id: outputNumber
        height: parent.height
        font.pixelSize: height * 0.6
        anchors.margins: height * 0.1
        anchors.left: parent.left
        text: controlOutput.output
        color: Global.buttonTextColor
        font.bold: true
        opacity: 0.1
        font.family: Global.alibabaPuHuiTi.font.family
    }
    MyIconLabel {
        id: textInput
        anchors.bottom: parent.bottom
        height: parent.height * 0.6
        width: parent.width - inputNumber.width
        alignment: Text.AlignRight
        icon.source: controlOutput.input > 0 & controlOutput.input <= controlOutput.inputListMode.count ? controlOutput.inputListMode.get(controlOutput.input - 1).source : ""
        text: controlOutput.input > 0 & controlOutput.input <= controlOutput.inputListMode.count ? controlOutput.inputListMode.get(controlOutput.input - 1).name : null
        anchors.right: parent.right
        anchors.rightMargin: inputNumber.width
    }
    Text {
        id: inputNumber
        height: parent.height * 0.4
        font.pixelSize: height
        anchors.margins: height * 0.1
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: controlOutput.input ? controlOutput.input : ""
        color: Global.buttonTextColor
        font.bold: true
        opacity: 0.1
        font.family: Global.alibabaPuHuiTi.font.family
    }
    Text {
        id: channel
        height: parent.height
        text: Global.settings.showChannel ? "A" + controlOutput.output + "E" + controlOutput.disableChannel : ""
        color: Global.buttonTextColor
        font.pixelSize: Global.channelSize
        font.family: Global.alibabaPuHuiTi.font.family
    }
    DropArea {
        id: dropContainer
        anchors.fill: parent
        onDropped: drop => CrestronCIP.level(controlOutput.output, drop.keys[0])
        onEntered: drop => controlOutput.dragShadowColor = drop.keys[1]
    }
}
