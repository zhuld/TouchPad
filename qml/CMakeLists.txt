# ===============================================================
# QML 模块定义（TouchPad）
# ===============================================================
# 本文件所在的 qml/ 目录即 QML 模块的根目录。
#
# 为什么模块定义放在这里而不是根 CMakeLists.txt：
#   qt_add_qml_module 会把「文件相对本文件所在目录的路径」拼接到
#   资源前缀 (/qt/qml/) + 模块目标路径 (TouchPad) 之后，即：
#       qml/Main.qml             → :/qt/qml/TouchPad/Main.qml
#       qml/pages/haishi/LED.qml → :/qt/qml/TouchPad/pages/haishi/LED.qml
#   这正是 src/main.cpp 中 loadFromModule("TouchPad", "Main") 期望的布局。
#   若在根 CMakeLists.txt 中直接写 "qml/Main.qml"，资源会落到
#   :/qt/qml/TouchPad/qml/Main.qml，模块将无法被加载。
#
# 维护提示：
#   QML 内部大量使用相对 URL 互相引用（如 Main.qml 的 Loader.source、
#   custom/*.qml 的 "../js/crestroncip.js"、config/*.qml 的 pageUrl）。
#   调整目录层级时，必须同步修正这些相对引用，否则运行期才会暴露。
# ===============================================================

# ---------------------------------------------------------------
# 将 Global.qml 标记为 QML 单例（singleton）：
#   QT_QML_SINGLETON_TYPE TRUE —— QML 代码中可直接以 "Global.xxx" 访问，
#   无需实例化，在整个模块内共享同一份数据。
#   该属性必须在文件被加入模块之前设置，否则 qmldir 不会写入 singleton。
# ---------------------------------------------------------------
set_source_files_properties(
    Global.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

# ---------------------------------------------------------------
# 为 TouchPad 目标添加 QML 模块：
#   URI TouchPad —— 模块的导入命名空间，QML 中写作 "import TouchPad"
#   VERSION 1.0  —— 模块版本号（主版本.次版本）
#   QML_FILES    —— 参与编译的 QML/JS 清单（编入 qrc 并自动生成 qmldir/qmltypes）：
#       Main.qml                 —— 主窗口（模块根组件）
#       Global.qml               —— 全局单例（通道状态 / 主题 / 持久化设置）
#       config/*.qml             —— 场所配置（ConfigSet / ShiyiMZ / Haishi410 / MediaPlayer）
#                                  与控件类型定义（CategoryType）
#       custom/*.qml             —— 自定义控件（按钮、开关、旋钮、音量条、内容区等）
#       dialog/*.qml             —— 对话框（确认 / 密码 / 进程 / 设置）
#       js/crestroncip.js        —— Crestron CIP 协议封装（帧打包解析 / 注册握手 / 心跳）
#       pages/*.qml              —— 顶层页面（配置选择、连接、内容布局、测试）
#       pages/haishi/*.qml       —— 海诗品牌控制页（摄像头 / LED / 遥控 / 单屏 / VR）
#       pages/mediaplayer/*.qml  —— 媒体播放页（Flash / 摄像头 / 系统 / 影片 / 图片 / PPT / 声音 / 网页）
#       pages/shiyi/*.qml        —— 世仪品牌控制页（摄像头 / 灯光 / 电源 / 系统 / 视频 / 音量）
#   SOURCES      —— 与 QML 模块绑定的 C++ 源码（通过 QML_ELEMENT / QML_SINGLETON
#                   注册为 QML 类型，路径相对本目录，因此需要 "../" 前缀）：
#       ../src/network/TcpClient —— TCP 客户端（生产模式：连接真实 Crestron 中控）
#       ../src/network/TcpServer —— TCP 服务端（演示模式：本机模拟中控）
# ---------------------------------------------------------------
qt_add_qml_module(TouchPad
    URI TouchPad
    VERSION 1.0
    QML_FILES
        Main.qml
        Global.qml
        config/CategoryType.qml
        config/ConfigSet.qml
        config/Haishi410.qml
        config/MediaPlayer.qml
        config/ShiyiMZ.qml
        custom/Background.qml
        custom/Category.qml
        custom/ColorButton.qml
        custom/ColorSwitch.qml
        custom/ControlPad.qml
        custom/Icon.qml
        custom/InputButton.qml
        custom/MyButton.qml
        custom/MyIconLabel.qml
        custom/MySwitch.qml
        custom/MyTabButton.qml
        custom/Output.qml
        custom/VButton.qml
        custom/VolumeBar.qml
        dialog/ConfirmDialog.qml
        dialog/PasswordDialog.qml
        dialog/ProcessDialog.qml
        dialog/SettingDialog.qml
        js/crestroncip.js
        pages/ConfigSelect.qml
        pages/Connect.qml
        pages/ContentColumn.qml
        pages/ContentRow.qml
        pages/Test.qml
        pages/haishi/Camera.qml
        pages/haishi/LED.qml
        pages/haishi/Remote.qml
        pages/haishi/SingleScreen.qml
        pages/haishi/VR.qml
        pages/mediaplayer/Flash.qml
        pages/mediaplayer/MediaCamera.qml
        pages/mediaplayer/MediaSystem.qml
        pages/mediaplayer/Movie.qml
        pages/mediaplayer/Picture.qml
        pages/mediaplayer/PPT.qml
        pages/mediaplayer/Sound.qml
        pages/mediaplayer/Web.qml
        pages/shiyi/CameraControl.qml
        pages/shiyi/Light.qml
        pages/shiyi/Power.qml
        pages/shiyi/System.qml
        pages/shiyi/Video.qml
        pages/shiyi/Volume.qml
    SOURCES
        ../src/network/TcpClient.cpp
        ../src/network/TcpClient.h
        ../src/network/TcpServer.cpp
        ../src/network/TcpServer.h
)
