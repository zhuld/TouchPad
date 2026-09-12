/**
 * @file Shiyi/Video.qml
 * @brief 视频矩阵页（拖拽切换输入/输出）
 *
 * 左卡片"输出信号"：Output 卡片网格（数据取 ShiyiMZ.vidoeOutput），
 *   显示每个输出通道当前接入的输入源，并作为拖拽放置目标；
 * 右卡片"输入信号"：InputButton 拖拽源网格（数据取 ShiyiMZ.vidoeInput），
 *   按住拖到输出卡片上即发 level(output, input) 切换命令；
 *   按住输入源时同步禁用其 disableOut 指定的互斥输出，防止误操作。
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Item {
    id: videoPage

    implicitWidth: parent.width
    implicitHeight: parent.height

    /// 当前被按住的输入按钮要求互斥禁用的输出通道号（-1 = 无）；
    /// 拖拽场景同一时刻只有一个输入按钮被按住，Output 卡片通过绑定自动响应
    property int pressedDisableOut: -1

    RowLayout {
        anchors.fill: parent
        Category {
            id: vidoeOutputCategory
            property CategoryType vidoeOutput: Global.configList[Global.shiyiMZ].vidoeOutput
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.3
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: vidoeOutput.label
            backIcon: vidoeOutput.backIcon
            content: Grid {
                id: gridOutput
                rows: 4
                anchors.fill: parent
                columns: Math.ceil(vidoeOutputCategory.vidoeOutput.list.count / rows)
                spacing: height * 0.05
                Repeater {
                    id: outputRepeater
                    model: vidoeOutputCategory.vidoeOutput.list
                    delegate: Output {
                        required property string name
                        required property int outputChannel
                        width: (gridOutput.width + gridOutput.spacing) / gridOutput.columns - gridOutput.spacing
                        height: (gridOutput.height + gridOutput.spacing) / gridOutput.rows - gridOutput.spacing
                        output: outputChannel
                        textOutput: name
                        // 该输出通道与被按住的输入按钮互斥时临时禁用（响应式绑定）
                        pressLock: videoPage.pressedDisableOut === outputChannel
                        inputListMode: vidoeInputCategory.vidoeInput.list
                    }
                }
            }
        }
        Category {
            id: vidoeInputCategory
            property CategoryType vidoeInput: Global.configList[Global.shiyiMZ].vidoeInput
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width * 0.7
            Layout.rightMargin: parent.width * 0.02
            Layout.bottomMargin: parent.width * 0.02
            label: vidoeInput.label
            backIcon: vidoeInput.backIcon
            info: MyIconLabel {
                height: parent.height
                icon.source: vidoeInputCategory.vidoeInput.infoIcon
                text: vidoeInputCategory.vidoeInput.info
            }
            content: Grid {
                id: gridInput
                rows: 4
                anchors.fill: parent
                columns: Math.ceil(vidoeInputCategory.vidoeInput.list.count / rows)
                spacing: height * 0.05
                Repeater {
                    model: vidoeInputCategory.vidoeInput.list
                    delegate: InputButton {
                        required property string name
                        required property int inputChannel
                        required property color bgColor
                        required property string source
                        required property int index
                        required property int btnChannel
                        required property int disableOut
                        width: (gridInput.width + gridInput.spacing) / gridInput.columns - gridInput.spacing
                        height: (gridInput.height + gridInput.spacing) / gridInput.rows - gridInput.spacing
                        btnColor: bgColor
                        textInput: name
                        input: inputChannel
                        iconSource: source
                        disableOutput: disableOut
                        // 按住时记录互斥输出通道到页面级状态，松开时清除；
                        // Output 卡片经 pressLock 绑定自动启停（不再命令式改写 enabled，
                        // 避免破坏 Output 内部 Global.digital 的 enabled 绑定）
                        onPressedChanged: pressed => {
                            videoPage.pressedDisableOut = pressed ? disableOutput : -1;
                        }
                    }
                }
            }
        }
    }
}
