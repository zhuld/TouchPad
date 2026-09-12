/**
 * @file CategoryType.qml
 * @brief 分类卡片配置类型（纯数据 QtObject）
 *
 * 定义 System.qml 等页面组装 Category 卡片所需的属性模板：
 *   label/backIcon：卡片标题与右下角水印图标；
 *   info/infoIcon：顶部提示文字与图标；
 *   list：卡片内的子项数据源（输出通道/输入源/音量条参数等，由页面解释使用）；
 *   channel/channelOn/channelOff：预留的通道字段。
 */

import QtQuick

Item {
    property string label
    property string backIcon
    property string info
    property string infoIcon
    property ListModel list
    property int channel
    property string channelOn
    property string channelOff
}
