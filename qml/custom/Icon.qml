/**
 * @file qml/custom/Icon.qml
 * @brief 基础图标组件（IconLabel 封装）
 *
 * 默认填充父项、图标取 80% 高度并使用全局文本色，
 * 颜色变化带 durationDelay 渐变动画（主题切换时平滑过渡）。
 */

import QtQuick
import QtQuick.Controls.impl

IconLabel {
    anchors.fill: parent
    icon.height: height * 0.8
    icon.width: height * 0.8
    icon.color: Global.buttonTextColor

    Behavior on icon.color {
        ColorAnimation {
            duration: Global.durationDelay
        }
    }
}
