/**
 * @file qml/pages/Test.qml
 * @brief 调试测试页（test=true 页签，仅 showChannel 调试模式下可见）
 *
 * 左卡片：RadialGradient 渐变按钮的实时预览（按压联动高光），
 *   用于目测按钮配色效果；
 * 右卡片：参数滑块组（centerY/centerRadius/focalX/focalY/focalRadius/height），
 *   调节左侧预览按钮的渐变参数与高宽比例，为设计新按钮配色提供参考。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Layouts

Item {
    implicitWidth: parent.width
    implicitHeight: parent.height
    RowLayout {
        anchors.fill: parent
        Category {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("测试")
            content: Column {
                spacing: parent.height * 0.1
                anchors.fill: parent
                Shape {
                    id: back
                    height: width * heightSlider.value
                    width: parent.width / 2
                    y: mouseArea.pressed ? Global.shadowHeight / 2 : 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    // containsMode: Shape.FillContains
                    layer.enabled: Global.settings.shadow
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: Global.buttonShadowColor
                        shadowHorizontalOffset: shadowVerticalOffset
                        shadowVerticalOffset: mouseArea.pressed ? Global.shadowHeight / 2 : Global.shadowHeight
                    }
                    ShapePath {
                        strokeWidth: 0
                        strokeColor: "transparent"
                        PathRectangle {
                            id: pathRect
                            x: 0
                            y: 0
                            radius: back.height / 5
                            width: back.width
                            height: back.height
                        }
                        fillGradient: RadialGradient {
                            id: gradient
                            centerX: back.width * 0.5
                            centerY: back.height * 0.5
                            focalX: back.width * 0.5
                            focalY: Math.max(back.width * 0.6, back.height)
                            centerRadius: Math.sqrt(Math.pow(back.width, 2) + Math.pow(back.height, 2)) / 2
                            focalRadius: 0
                            property real pos: mouseArea.pressed ? 1 : 0
                            GradientStop {
                                position: -0.8 + gradient.pos
                                color: Global.buttonCheckedColor
                            }
                            GradientStop {
                                position: 0 + gradient.pos
                                color: Qt.darker(Global.buttonColor, 1.5)
                            }
                            GradientStop {
                                position: 1 + gradient.pos
                                color: Global.buttonColor
                            }
                            GradientStop {
                                position: 2 + gradient.pos
                                color: Global.buttonColor
                            }

                            Behavior on pos {
                                NumberAnimation {
                                    duration: Global.durationDelay
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
            }
        }
        Category {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: qsTr("参数")
            content: Column {
                id: parameter
                spacing: height * 0.01
                anchors.fill: parent
                Slider {
                    id: centerXSlider
                    width: parameter.width * 0.7
                    height: width * 0.1
                    value: 0.5
                    from: 0
                    to: 1
                    stepSize: 0.1
                    snapMode: Slider.SnapAlways
                    Text {
                        height: parent.height
                        width: parameter.width * 0.3
                        text: 'centerX' + ":" + parent.value
                        anchors.left: parent.right
                    }
                }
                Slider {
                    id: centerYSlider
                    width: parameter.width * 0.7
                    height: width * 0.1
                    value: 0.5
                    from: -1
                    to: 2
                    stepSize: 0.1
                    snapMode: Slider.SnapAlways
                    Text {
                        height: parent.height
                        width: parameter.width * 0.3
                        text: 'centerY' + ":" + parent.value
                        anchors.left: parent.right
                    }
                }
                Slider {
                    id: centerRadiusSlider
                    width: parameter.width * 0.7
                    height: width * 0.1
                    value: 0.5
                    from: 0
                    to: 3
                    stepSize: 0.1
                    snapMode: Slider.SnapAlways
                    Text {
                        height: parent.height
                        width: parameter.width * 0.3
                        text: 'centerRadius' + ":" + parent.value
                        anchors.left: parent.right
                    }
                }
                Slider {
                    id: focalXSlider
                    width: parameter.width * 0.7
                    height: width * 0.1
                    value: 0.5
                    from: 0
                    to: 1
                    stepSize: 0.1
                    snapMode: Slider.SnapAlways
                    Text {
                        height: parent.height
                        width: parameter.width * 0.3
                        text: 'focalX' + ":" + parent.value
                        anchors.left: parent.right
                    }
                }
                Slider {
                    id: focalYSlider
                    width: parameter.width * 0.7
                    height: width * 0.1
                    value: 1
                    from: -1
                    to: 2
                    stepSize: 0.1
                    snapMode: Slider.SnapAlways
                    Text {
                        height: parent.height
                        width: parameter.width * 0.3
                        text: 'focalY' + ":" + parent.value
                        anchors.left: parent.right
                    }
                }
                Slider {
                    id: focalRadiusSlider
                    width: parameter.width * 0.7
                    height: width * 0.1
                    value: 0
                    from: 0
                    to: 2
                    stepSize: 0.1
                    snapMode: Slider.SnapAlways
                    Text {
                        height: parent.height
                        width: parameter.width * 0.3
                        text: 'focalRadius' + ":" + parent.value
                        anchors.left: parent.right
                    }
                }

                Slider {
                    id: heightSlider
                    width: parameter.width * 0.7
                    height: width * 0.1
                    value: 0.5
                    from: 0.1
                    to: 2
                    stepSize: 0.1
                    snapMode: Slider.SnapAlways
                    Text {
                        height: parent.height
                        width: parameter.width * 0.3
                        text: 'height' + ":" + parent.value
                        anchors.left: parent.right
                    }
                }
            }
        }
    }
}
