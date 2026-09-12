/**
 * @file qml/custom/ControlPad.qml
 * @brief 方向控制盘（云台/光标类控制）
 *
 * 布局（Column）：
 *   1. 方形 pad 区：上/下/左/右四个三角形热区（Repeater 生成，
 *      三角形坐标与归属存于 ListModel；通道为 channel+0..3，
 *      按下发 push、抬起发 release，相邻热区拖入可滑动切换）；
 *   2. 中央 confirm 键（channel+4 区域内可拖拽的圆钮，压下/松开
 *      同样发 push/release，拖动范围限制在 pad 的 1/3）；
 *   3. 底部放大/缩小按钮（channel+4/+5，复用 MyButton）。
 * 调试：showChannel 打开时左上角显示 "D+channel"。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

import "../js/crestroncip.js" as CrestronCIP

Item {
    id: controlPad

    property color btnColor: Global.buttonColor
    property color btnCheckColor: Global.buttonCheckedColor
    property int channel
    property int disableChannel: 0
    property color textCheckedColor: Global.buttonTextCheckedColor
    property color textColor: Global.buttonTextColor
    enabled: Global.digital[disableChannel] ? false : true
    opacity: enabled ? 1 : Global.disableOpacity

    implicitWidth: 100
    implicitHeight: 130

    Column {
        anchors.fill: parent
        spacing: width * 0.05
        Item {
            id: pad
            width: parent.width
            height: width
            Text {
                text: Global.settings.showChannel ? "D" + controlPad.channel : ""
                color: Global.buttonTextColor
                font.pixelSize: Global.channelSize
                font.family: Global.alibabaPuHuiTi.font.family
            }
            Repeater {
                model: ListModel {
                    Component.onCompleted: {
                        append({
                            "channel": controlPad.channel,
                            "icon": "qrc:/icons/up.svg",
                            "x1": 0.2,
                            "y1": 0.1,
                            "x2": 0.8,
                            "y2": 0.1,
                            "x3": 0.62,
                            "y3": 0.3,
                            "x4": 0.38,
                            "y4": 0.3,
                            "leftP": 1,
                            "rightP": 1,
                            "topP": 0,
                            "bottomP": 2
                        });
                        append({
                            "channel": controlPad.channel + 1,
                            "icon": "qrc:/icons/down.svg",
                            "x1": 0.8,
                            "y1": 0.9,
                            "x2": 0.2,
                            "y2": 0.9,
                            "x3": 0.38,
                            "y3": 0.7,
                            "x4": 0.62,
                            "y4": 0.7,
                            "leftP": 1,
                            "rightP": 1,
                            "topP": 2,
                            "bottomP": 0
                        });
                        append({
                            "channel": controlPad.channel + 2,
                            "icon": "qrc:/icons/left.svg",
                            "x1": 0.1,
                            "y1": 0.8,
                            "x2": 0.1,
                            "y2": 0.2,
                            "x3": 0.3,
                            "y3": 0.38,
                            "x4": 0.3,
                            "y4": 0.62,
                            "leftP": 0,
                            "rightP": 2,
                            "topP": 1,
                            "bottomP": 1
                        });
                        append({
                            "channel": controlPad.channel + 3,
                            "icon": "qrc:/icons/right.svg",
                            "x1": 0.9,
                            "y1": 0.2,
                            "x2": 0.9,
                            "y2": 0.8,
                            "x3": 0.7,
                            "y3": 0.62,
                            "x4": 0.7,
                            "y4": 0.38,
                            "leftP": 2,
                            "rightP": 0,
                            "topP": 1,
                            "bottomP": 1
                        });
                    }
                }
                delegate: Shape {
                    id: button
                    required property int channel
                    required property string icon
                    required property real x1
                    required property real y1
                    required property real x2
                    required property real y2
                    required property real x3
                    required property real y3
                    required property real x4
                    required property real y4
                    required property int leftP
                    required property int rightP
                    required property int topP
                    required property int bottomP
                    property bool checked: Global.digital[button.channel] ? true : false
                    width: parent.width
                    height: width
                    y: checked ? Global.shadowHeight / 2 : 0
                    Behavior on y {
                        NumberAnimation {
                            duration: Global.durationDelay
                        }
                    }
                    containsMode: Shape.FillContains
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: Global.buttonShadowColor
                        shadowHorizontalOffset: shadowVerticalOffset / 2
                        shadowVerticalOffset: Global.settings.shadow ? (button.checked ? Global.shadowHeight / 2 : Global.shadowHeight) : 0
                        Behavior on shadowHorizontalOffset {
                            NumberAnimation {
                                duration: Global.durationDelay
                            }
                        }
                    }
                    ShapePath {
                        strokeWidth: Math.ceil(pad.width * 0.004)
                        strokeColor: Qt.darker(controlPad.btnColor, 1.5)
                        fillGradient: RadialGradient {
                            id: buttonGradient
                            centerX: pad.width * 0.5
                            centerY: pad.width * 0.5
                            focalX: pad.width * 0.5
                            focalY: pad.width * 0.5
                            centerRadius: pad.width * 0.8
                            property real pos: button.checked ? 0.6 : 0
                            Behavior on pos {
                                NumberAnimation {
                                    duration: Global.durationDelay
                                }
                            }
                            GradientStop {
                                position: -0.2 + buttonGradient.pos
                                color: controlPad.btnCheckColor
                            }
                            GradientStop {
                                position: 0.4 + buttonGradient.pos
                                color: Qt.darker(controlPad.btnColor, 1.5)
                            }
                            GradientStop {
                                position: 1 + buttonGradient.pos
                                color: controlPad.btnColor
                            }
                        }

                        startX: pad.width * button.x1
                        startY: pad.height * button.y1

                        PathArc {
                            x: pad.width * button.x2
                            y: pad.height * button.y2
                            radiusX: pad.width / 2
                            radiusY: pad.width / 2
                        }
                        PathLine {
                            x: pad.width * button.x3
                            y: pad.height * button.y3
                        }
                        PathArc {
                            x: pad.width * button.x4
                            y: pad.height * button.y4
                            radiusX: pad.width / 4
                            radiusY: pad.width / 4
                            direction: PathArc.Counterclockwise
                        }
                        PathLine {
                            x: pad.width * button.x1
                            y: pad.height * button.y1
                        }
                    }
                    MouseArea {
                        anchors.fill: button
                        containmentMask: button
                        onPressedChanged: {
                            if (pressed) {
                                CrestronCIP.push(button.channel);
                            } else {
                                CrestronCIP.release(button.channel);
                            }
                        }
                    }
                    DropArea {
                        anchors.fill: button
                        containmentMask: button
                        onDropped: CrestronCIP.release(button.channel)
                        onExited: CrestronCIP.release(button.channel)
                        onEntered: CrestronCIP.push(button.channel)
                    }
                    MyIconLabel {
                        icon.height: height / 4
                        icon.width: width / 4
                        icon.source: button.icon
                        icon.color: button.checked ? Global.buttonTextCheckedColor : Global.buttonTextColor
                        height: button.height
                        width: button.width
                        leftPadding: width * button.leftP * 1 / 3
                        rightPadding: width * button.rightP * 1 / 3
                        topPadding: height * button.topP * 1 / 3
                        bottomPadding: height * button.bottomP * 1 / 3
                    }
                }
            }

            Item {
                anchors.margins: pad.width * 0.36
                anchors.fill: pad
                Shape {
                    id: centerButton
                    Behavior on x {
                        NumberAnimation {
                            duration: Global.durationDelay
                        }
                    }
                    Behavior on y {
                        NumberAnimation {
                            duration: Global.durationDelay
                        }
                    }
                    x: 0
                    y: 0
                    width: parent.width
                    height: parent.height
                    layer.enabled: Global.settings.shadow
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: Global.buttonShadowColor
                        shadowHorizontalOffset: shadowVerticalOffset / 2
                        shadowVerticalOffset: centerMouseArea.pressed ? Global.shadowHeight / 2 : Global.shadowHeight
                        Behavior on shadowHorizontalOffset {
                            NumberAnimation {
                                duration: Global.durationDelay
                            }
                        }
                    }
                    MyIconLabel {
                        icon.source: "qrc:/icons/center.svg"
                        icon.color: centerMouseArea.pressed ? Global.buttonTextCheckedColor : Global.buttonTextColor
                        height: parent.height
                        width: parent.width
                    }
                    ShapePath {
                        strokeWidth: Math.ceil(pad.width * 0.004)
                        strokeColor: Qt.darker(controlPad.btnColor, 1.5)
                        fillGradient: RadialGradient {
                            id: centerButtonGradient
                            centerX: centerButton.width * 0.5
                            centerY: centerButton.width * 0.5
                            focalX: centerButton.width * 0.5
                            focalY: centerButton.width * 0.5
                            centerRadius: centerButton.width / 2

                            GradientStop {
                                position: 1
                                color: Qt.darker(controlPad.btnColor, 1.5)
                            }
                            GradientStop {
                                position: 0
                                color: centerMouseArea.pressed ? controlPad.btnCheckColor : controlPad.btnColor
                            }
                        }
                        PathRectangle {
                            width: centerButton.width
                            height: centerButton.height
                            radius: height / 2
                        }
                    }
                    Drag.active: centerMouseArea.drag.active
                    MouseArea {
                        id: centerMouseArea
                        anchors.fill: centerButton
                        drag.target: centerButton

                        drag.axis: Drag.XAxis | Drag.YAxis
                        drag.minimumX: -pad.width / 3
                        drag.maximumX: pad.width / 3
                        drag.minimumY: -pad.height / 3
                        drag.maximumY: pad.height / 3

                        hoverEnabled: true
                        onPressedChanged: {
                            if (pressed) {
                                centerButton.z = 1; // 提升层级，避免被遮挡
                                centerButton.Drag.hotSpot.x = centerButton.width / 2;
                                centerButton.Drag.hotSpot.y = centerButton.height / 2;
                            } else {
                                centerButton.z = 0; // 恢复默认层级
                                centerButton.Drag.drop();
                                centerButton.y = 0;
                                centerButton.x = 0;
                            }
                        }
                    }
                }
            }
        }

        Row {
            height: parent.width * 0.25
            width: parent.width
            spacing: width - 2 * height
            MyButton {
                height: parent.height
                width: height
                source: "qrc:/icons/fangda"
                radius: height / 2
                channel: controlPad.channel + 4
                textColor: checked ? controlPad.textCheckedColor : controlPad.textColor
            }
            MyButton {
                height: parent.height
                width: height
                source: "qrc:/icons/suoxiao"
                radius: height / 2
                channel: controlPad.channel + 5
                textColor: checked ? controlPad.textCheckedColor : controlPad.textColor
            }
        }
    }
}
