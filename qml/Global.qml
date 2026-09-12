pragma Singleton

import QtQuick
import QtCore

/**
 * @brief 全局单例对象（QML 任意位置可直接使用 Global.xxx 访问）
 *
 * 集中管理三大类全局状态：
 *   1. Crestron 设备通道状态（digital / digitalToggle / analog）；
 *   2. UI 主题与公共样式（颜色、字号、动画时长、阴影）；
 *   3. 应用设置持久化（Global.settings，自动写入本地配置文件）。
 */
QtObject {

    // ======================== 通道状态区 ========================
    // 与 Crestron 中控交互的设备状态缓存（由 crestroncip.js 更新）
    property list<bool> digital: []        // 数字量状态：true=按下/高电平，false=松开/低电平（下标 = 通道号-1）
    property list<bool> digitalToggle: []  // 数字量开关锁定标志：为 true 时对应 digital 通道忽略释放包
    property list<int> analog: []          // 模拟量值（0~65535），如音量、亮度等

    // ======================== 配置列表区 ========================
    // 场所配置文件列表，与设置中的"配置选择"一一对应（下标即索引）
    readonly property list<QtObject> configList: [
        ConfigSet {},    // 0：启动页面（配置文件选择）
        ShiyiMZ {},      // 1：市一医院 指挥中心会议室
        Haishi410 {},    // 2：海事大学 410 沉浸式教室
        MediaPlayer {}   // 3：媒体播放器控制面板
    ]

    // 注意：configList 下标即对应配置文件索引（与设置里的 configSetting 一致）。
    // 原 shiyiMZ/haishi410/mediaPlayer 三个常量中只有 shiyiMZ 被页面使用，
    // haishi410/mediaPlayer 从未被引用，属于死代码，已删除。
    readonly property int shiyiMZ: 1

    // 配置选择页下拉框使用的简易字符串模型（由 configList 各配置的 logoName/titleName 生成）
    readonly property ListModel configListModel: ListModel {}

    Component.onCompleted: {
        // 初始化配置选择下拉框的数据项："Logo名-标题名"
        for (var i = 0; i < configList.length; i++) {
            configListModel.append({
                "key": configList[i].logoName + "-" + configList[i].titleName
            });
        }
    }

    // ======================== 主题配色区 ========================
    // 全部颜色随"深色/浅色"主题联动
    readonly property color buttonColor: settings.darkTheme ? "#FF0B79BD" : "#8AD6FC"          // 按钮主体色
    readonly property color buttonCheckedColor: "#FFFF8E47"                                    // 按钮选中/按下高亮色
    readonly property color backgroundColor: settings.darkTheme ? "#FF455681" : "#FFdeebfe"    // 窗口背景色
    readonly property color buttonTextColor: settings.darkTheme ? "#FFCFD2EC" : "#FF0D185D"    // 常规文字色
    readonly property color buttonTextCheckedColor: settings.darkTheme ? "#FFE6E6E6" : "#FF0D185D" // 选中态文字色
    readonly property color buttonTextShadowColor: settings.darkTheme ? "#FF0D185D" : "#FFCFD2EC" // 文字阴影色
    readonly property color buttonShadowColor: settings.darkTheme ? "#FF2E2E4C" : "#FF666C75"  // 控件投影色
    readonly property color buttonWarnColor: "darkred"                                          // 告警/消极状态色（如静音、刻度越界）

    // ======================== 动效与尺寸公共参数 ========================
    // 动画时长：低性能模式（不开阴影）时统一为 0，即关闭动画
    readonly property int durationDelay: settings.shadow ? 50 : 0

    readonly property real channelSize: 20       // 调试显示通道号时的字号
    readonly property real shadowHeight: 4       // 控件投影基础高度（px）
    readonly property real disableOpacity: 0.6   // 控件禁用时的透明度

    // ======================== 演示模式参数 ========================
    // 演示模式下本机模拟中控服务器，无需真实中控即可体验界面
    readonly property string demoIP: "127.0.0.1"
    readonly property int demoPort: 41793
    readonly property int demoIPID: 3

    // ======================== 全局字体 ========================
    readonly property FontLoader lcdFont: FontLoader {
        source: "qrc:/fonts/TP-LCD.TTF" // 七段液晶数显字体（时钟/仪表盘）
    }
    readonly property FontLoader alibabaPuHuiTi: FontLoader {
        source: "qrc:/fonts/AlibabaPuHuiTi-3-55-Regular.ttf" // 界面主字体（阿里巴巴普惠体）
    }
    readonly property FontLoader sourceCodePro: FontLoader {
        source: "qrc:/fonts/SourceCodePro-Regular.ttf" // 等宽字体（代码/数值展示备用）
    }

    // ======================== 应用设置区（持久化存储）=================
    property var settings: Settings {
        property int configSetting: 0          // 当前启用哪个配置文件（0=启动页）
        property string ipAddress: "192.168.1.10" // 中控服务器 IP
        property int ipPort: 41794             // 中控服务器端口
        property int ipId: 3                   // 本设备 IPID（Crestron 注册用）
        property bool fullscreen: Qt.platform.os === "windows" ? false : true // Windows 默认窗口模式，移动端默认全屏
        property string settingPassword: "123" // 进入设置页的密码（默认 123）
        property bool demoMode: false          // 演示模式开关
        property bool showChannel: false       // 调试开关：显示通道号 & 收发日志、显示测试页
        property bool darkTheme: false         // 深色主题开关
        property int windowWidth: 800          // 窗口宽（记忆上次拖拽大小）
        property int windowHeight: 500         // 窗口高
        property bool shadow: false            // 阴影特效开关（低性能设备关闭）
    }
}
