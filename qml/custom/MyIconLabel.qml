/**
 * @file qml/custom/MyIconLabel.qml
 * @brief 图标+文字标签（IconLabel 封装，全项目最基础的文字/图标元素）
 *
 * 统一使用全局主题色与阿里巴巴普惠体，
 * 颜色变化带 durationDelay 渐变动画；始终叠加轻微文字阴影。
 */

import QtQuick
import QtQuick.Controls.impl
import QtQuick.Effects

IconLabel {
    icon.height: height / 2
    icon.width: height / 2
    icon.color: Global.buttonTextColor
    font.pixelSize: height * 0.4
    color: Global.buttonTextColor
    font.family: Global.alibabaPuHuiTi.font.family
    spacing: height * 0.1
    Behavior on color {
        ColorAnimation {
            duration: Global.durationDelay
        }
    }
    Behavior on icon.color {
        ColorAnimation {
            duration: Global.durationDelay
        }
    }
    layer.enabled: Global.settings.shadow
    layer.effect: MultiEffect {
        shadowEnabled: true
        //启用阴影效果。
        shadowBlur: 0.2
        //阴影的模糊程度（范围 0.0 到 1.0）。
        shadowColor: Global.buttonTextShadowColor
        //阴影的颜色（默认为黑色）。
        shadowVerticalOffset: 0.5
        //阴影的垂直偏移量。
        shadowHorizontalOffset: 0.2
        //阴影的水平偏移量。
        autoPaddingEnabled: true
        //如果设置为 true，MultiEffect 会自动增加自身的大小（Padding），以确保阴影不会被裁剪。通常建议设置为 true。
    }
}
