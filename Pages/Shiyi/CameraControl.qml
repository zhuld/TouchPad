/**
 * @file Shiyi/CameraControl.qml
 * @brief 摄像机控制页（云台 + 预置位）
 *
 * 左卡片：摄像机选择按钮行（ShiyiMZ.cameraControl，D 键）+
 *   ControlPad 方向盘（基通道 cameraControl.channel，含缩放键）；
 * 右卡片"预置位"：顶部 cameraAuto 开关（自动/手动跟踪，
 *   开关联动本页所有按钮的 disableChannel），
 *   下方 Shape 径向渐变底板内GridLayout 排布预置位按钮
 *   （ShiyiMZ.position，center 为真的按钮跨两列居中）。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Layouts

Item {
    implicitWidth: parent.width
    implicitHeight: parent.height
    RowLayout {
        anchors.fill: parent
        Category {
            id: cameraCategory
            property CategoryType cameraControl: Global.configList[Global.shiyiMZ].cameraControl
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: cameraControl.label
            backIcon: cameraControl.backIcon
            content: Column {
                anchors.fill: parent
                spacing: cameraCategory.cameraControl.list === null ? 0 : parent.height * 0.1
                Row {
                    id: cameraRow
                    width: parent.width
                    height: parent.height * 0.1
                    spacing: parent.width * 0.05
                    Repeater {
                        model: cameraCategory.cameraControl.list
                        delegate: MyButton {
                            required property int btnchannel
                            required property string label
                            width: (parent.width + cameraRow.spacing) / 3 - cameraRow.spacing
                            height: parent.height
                            channel: btnchannel
                            text: label
                            disableChannel: cameraAuto.channel
                        }
                    }
                }

                ControlPad {
                    id: dpadControl
                    width: cameraCategory.cameraControl.list === null ? parent.width * 1.3 > parent.height * 0.9 ? parent.height * 0.9 / 1.3 : parent.width * 0.8 : parent.width * 1.3 > parent.height * 0.8 ? parent.height * 0.8 / 1.3 : parent.width * 0.8
                    height: width * 1.3
                    anchors.horizontalCenter: parent.horizontalCenter
                    channel: cameraCategory.cameraControl.channel
                    disableChannel: cameraAuto.channel
                }
            }
        }
        Category {
            id: positionCategory
            property CategoryType position: Global.configList[Global.shiyiMZ].position
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: position.label
            backIcon: position.backIcon
            info: MySwitch {
                id: cameraAuto
                channel: positionCategory.position.channel
                text: checked ? positionCategory.position.channelOn : positionCategory.position.channelOff
                height: parent.height * 0.7
                width: height * 2
                anchors.verticalCenter: parent.verticalCenter
            }
            content: Column {
                anchors.fill: parent
                spacing: parent.height * 0.08
                Rectangle {
                    width: parent.width * 0.6
                    height: parent.height * 0.02
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.darker(Global.backgroundColor, 1.2)
                }
                Shape {
                    id: back
                    width: parent.width * 0.8
                    height: parent.height * 0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    // containsMode: Shape.FillContains
                    layer.enabled: Global.settings.shadow
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: Global.buttonShadowColor
                        shadowHorizontalOffset: shadowVerticalOffset
                        shadowVerticalOffset: Global.shadowHeight
                    }
                    opacity: 0.8
                    ShapePath {
                        strokeWidth: 0
                        strokeColor: "transparent"
                        PathRectangle {
                            id: pathRect
                            x: 0
                            y: 0
                            width: back.width
                            height: back.height
                            radius: height / 20
                        }
                        fillGradient: RadialGradient {
                            centerX: back.width * 0.5
                            centerY: back.height * 0.5
                            centerRadius: Math.max(back.width, back.height)
                            focalX: back.width * 0.5
                            focalY: back.height
                            GradientStop {
                                position: 0
                                color: Qt.darker(Global.backgroundColor, 1.2)
                            }
                            GradientStop {
                                position: 1
                                color: Qt.lighter(Global.backgroundColor, 1.2)
                            }
                        }
                    }
                    GridLayout {
                        id: grid
                        anchors.fill: parent
                        columns: 2
                        columnSpacing: parent.width * 0.5
                        anchors.margins: parent.width * 0.05
                        Repeater {
                            model: positionCategory.position.list
                            delegate: MyButton {
                                required property int btnchannel
                                required property int cameraRotation
                                required property string label
                                required property bool center
                                width: (grid.width + grid.columnSpacing) / grid.columns - grid.columnSpacing
                                height: width
                                channel: btnchannel
                                text: label
                                disableChannel: cameraAuto.channel
                                Layout.columnSpan: center ? 2 : 1
                                Layout.preferredWidth: width
                                Layout.preferredHeight: height
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
