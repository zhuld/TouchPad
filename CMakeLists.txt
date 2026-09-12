# ---------------------------------------------------------------
# 最低 CMake 版本要求：3.16（Qt 6 官方推荐的最低版本）
# ---------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)

# ---------------------------------------------------------------
# 项目定义：
#   TouchPad      —— 项目/目标名称
#   VERSION 0.1   —— 项目版本号，会填充 PROJECT_VERSION / PROJECT_VERSION_MAJOR 等变量
#   LANGUAGES CXX —— 仅启用 C++ 语言（Qt 项目无需显式启用 C）
# ---------------------------------------------------------------
project(TouchPad VERSION 0.1 LANGUAGES CXX)

# ===================== CMake 全局变量 =====================

# CMAKE_AUTOMOC：自动运行 moc（元对象编译器），
# 处理包含 Q_OBJECT / QML_ELEMENT / QML_SINGLETON 等宏的头文件与源文件。
set(CMAKE_AUTOMOC ON)

# CMAKE_AUTORCC：自动运行 rcc（资源编译器），
# 将源码列表中出现的 .qrc 资源文件编译进程序。
set(CMAKE_AUTORCC ON)

# CMAKE_CXX_STANDARD_REQUIRED：若编译器不支持所设置的 C++ 标准，
# 直接报错而不是静默回退到更旧的标准（保证代码按预期标准编译）。
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ---------------------------------------------------------------
# 跳过 Qt 私有模块 QmlAssetDownloaderPrivate（仅 QML 语言服务器 qmlls 使用），
# 避免其因缺少 QtTaskTree（未安装 "Qt Tools" 组件）而产生的 find_package 警告。
# 该变量必须在 find_package(Qt6 ...) 之前设置才会生效。
# ---------------------------------------------------------------
set(CMAKE_DISABLE_FIND_PACKAGE_Qt6QmlAssetDownloaderPrivate TRUE)

# ---------------------------------------------------------------
# 查找 Qt6 的 Quick 模块：
#   REQUIRED         —— 找不到则直接配置失败
#   COMPONENTS Quick —— 依赖 QML/Quick 构建界面（会自动带入 Core、Gui、Qml 等依赖模块）
# 成功后定义 Qt6::Quick 导入目标及 QT_VERSION 等变量。
# ---------------------------------------------------------------
find_package(Qt6 REQUIRED COMPONENTS Quick)

# ---------------------------------------------------------------
# 将 Global.qml 标记为 QML 单例（singleton）：
#   QT_QML_SINGLETON_TYPE TRUE —— QML 代码中可直接以 "Global.xxx" 访问，
#   无需实例化，在整个模块内共享同一份数据。
# ---------------------------------------------------------------
set_source_files_properties(
    Global.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

# ---------------------------------------------------------------
# Qt 项目统一初始化（Qt 6.3+ 提供）：
#   自动设置 C++17 标准、启用 AUTOMOC/AUTORCC/AUTOUIC、配置 QML/资源构建约定。
#   REQUIRES 6.10 —— 要求 Qt 版本 >= 6.10，否则配置失败。
# ---------------------------------------------------------------
qt_standard_project_setup(REQUIRES 6.10)

# ---------------------------------------------------------------
# 创建可执行目标 TouchPad：
#   main.cpp —— C++ 入口（QGuiApplication + QQmlApplicationEngine）
#   res.qrc  —— 静态资源文件（配合 CMAKE_AUTORCC 自动编译）
# ---------------------------------------------------------------
qt_add_executable(TouchPad
    main.cpp res.qrc
)

# ---------------------------------------------------------------
# 为 TouchPad 添加 QML 模块：
#   URI TouchPad —— 模块的导入命名空间，QML 中写作 "import TouchPad"
#   VERSION 1.0  —— 模块版本号（主版本.次版本）
#   QML_FILES    —— 参与编译的 QML 文件清单（编入 qrc 并自动生成 qmldir/qmltypes）：
#       Global.qml              —— 全局单例
#       Config/*.qml            —— 各配置页面（Haishi410 / MediaPlayer / ShiyiMZ 等）
#       Custom/*.qml            —— 自定义控件（按钮、开关、旋钮、音量条等）
#       Dialog/*.qml            —— 对话框（确认 / 密码 / 进程 / 设置）
#       Js/crestroncip.js       —— Crestron CIP 协议 JS 脚本
#       Pages/*.qml             —— 页面（配置选择、连接、内容布局、测试等）
#       Pages/Haishi/*.qml      —— 海诗品牌设备控制页（摄像头 / LED / 遥控 / 单屏 / VR）
#       Pages/Mediaplayer/*.qml —— 媒体播放页（Flash / 摄像头 / 系统 / 影片 / 图片 / PPT / 声音 / 网页）
#       Pages/Shiyi/*.qml       —— 世仪品牌设备控制页（摄像头 / 灯光 / 电源 / 系统 / 视频 / 音量）
#   SOURCES      —— 与 QML 模块绑定的 C++ 源码：
#       TcpClient / TcpServer   —— TCP 网络通信客户端与服务器封装
#   RESOURCES    —— 模块内附加资源文件（agent.md 说明文档）
# ---------------------------------------------------------------
qt_add_qml_module(TouchPad
    URI TouchPad
    VERSION 1.0
    QML_FILES
        Main.qml
        Global.qml
        Config/CategoryType.qml
        Config/ConfigSet.qml
        Config/Haishi410.qml
        Config/MediaPlayer.qml
        Config/ShiyiMZ.qml
        Custom/Background.qml
        Custom/Category.qml
        Custom/ColorButton.qml
        Custom/ColorSwitch.qml
        Custom/ControlPad.qml
        Custom/Icon.qml
        Custom/InputButton.qml
        Custom/MyButton.qml
        Custom/MyIconLabel.qml
        Custom/MySwitch.qml
        Custom/MyTabButton.qml
        Custom/Output.qml
        Custom/VButton.qml
        Custom/VolumeBar.qml
        Dialog/ConfirmDialog.qml
        Dialog/PasswordDialog.qml
        Dialog/ProcessDialog.qml
        Dialog/SettingDialog.qml
        Js/crestroncip.js
        Pages/Haishi/Camera.qml
        Pages/Haishi/LED.qml
        Pages/Haishi/Remote.qml
        Pages/Haishi/SingleScreen.qml
        Pages/Haishi/VR.qml
        Pages/Mediaplayer/Flash.qml
        Pages/Mediaplayer/MedaiCamera.qml
        Pages/Mediaplayer/MediaSystem.qml
        Pages/Mediaplayer/Movie.qml
        Pages/Mediaplayer/Picture.qml
        Pages/Mediaplayer/PPT.qml
        Pages/Mediaplayer/Sound.qml
        Pages/Mediaplayer/Web.qml
        Pages/Shiyi/CameraControl.qml
        Pages/Shiyi/Light.qml
        Pages/Shiyi/Power.qml
        Pages/Shiyi/System.qml
        Pages/Shiyi/Video.qml
        Pages/Shiyi/Volume.qml
        Pages/ConfigSelect.qml
        Pages/Connect.qml
        Pages/ContentColumn.qml
        Pages/ContentRow.qml
        Pages/Test.qml
    SOURCES
        cpp/TcpClient.cpp
        cpp/TcpClient.h
        cpp/TcpServer.cpp
        cpp/TcpServer.h
    RESOURCES
        agent.md
)

# ---------------------------------------------------------------
# 目标属性设置（macOS bundle / Windows / Android 相关）：
#   MACOSX_BUNDLE TRUE —— 在 macOS/iOS 上构建为 .app bundle。
#       注：Qt 6.1+ 会自动设置 MACOSX_BUNDLE_GUI_IDENTIFIER，
#       如需固定标识符，可取消下面注释行手动指定。
#   MACOSX_BUNDLE_BUNDLE_VERSION       —— bundle 内部构建版本号（取完整项目版本 0.1）
#   MACOSX_BUNDLE_SHORT_VERSION_STRING —— bundle 对外显示的短版本号（仅主.次版本 0.1）
#   WIN32_EXECUTABLE TRUE —— Windows 上构建为 GUI 程序（运行时不弹出控制台窗口）
#   QT_ANDROID_PACKAGE_SOURCE_DIR —— Android 打包源目录（含 AndroidManifest.xml 等）
#   QT_ANDROID_APP_ICON           —— Android 应用图标（资源引用 "@drawable/icon"）
# ---------------------------------------------------------------
set_target_properties(TouchPad PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTouchPad
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    QT_ANDROID_APP_ICON "@drawable/icon"
)

# ---------------------------------------------------------------
# 链接 Qt6::Quick 库：
#   PRIVATE —— 仅 TouchPad 自身使用，不向下游目标传递依赖；
#   链接后可直接使用 Quick/Qml 的全部 C++ API。
# ---------------------------------------------------------------
target_link_libraries(TouchPad
    PRIVATE Qt6::Quick
)

# ---------------------------------------------------------------
# 安装规则（cmake --install / make install 时生效）：
#   BUNDLE  —— macOS 的 .app 安装到根目录 "."
#   LIBRARY —— 非 macOS 动态库安装到 CMAKE_INSTALL_LIBDIR（默认 lib）
#   RUNTIME —— Windows/Linux 可执行文件安装到 CMAKE_INSTALL_BINDIR（默认 bin）
# ---------------------------------------------------------------
install(TARGETS TouchPad
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# ---------------------------------------------------------------
# 头文件搜索目录：
#   将 <项目根>/cpp 目录加入 TouchPad 的私有（PRIVATE）包含路径，
#   使 main.cpp 等可直接 #include "TcpClient.h"。
# ---------------------------------------------------------------
target_include_directories(TouchPad PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/cpp)
