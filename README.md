# TouchPad

基于 **Qt 6 / QML** 的 Crestron 中控触控面板应用。通过 TCP 连接 Crestron 中控主机，收发 **CIP 协议** 数据帧，实现对会议室设备（摄像头、灯光、电源、音量、视频矩阵、媒体播放等）的集中触控管理。

支持多场所配置（市一医院指挥中心、海事大学 410 沉浸式教室、媒体播放器面板等），可运行于 **Windows / Android / macOS**。

## 功能特性

- **多场所配置**：通过配置文件切换不同会议室的控制界面（ConfigSelect 选择，Settings 持久化）
- **双网络角色**：
  - **生产模式**：`TcpClient` 作为客户端连接真实 Crestron 中控
  - **演示模式**：`TcpServer` 在本机模拟中控服务器，无需真实硬件即可体验界面，也可配合 Crestron 官方 APP 联调
- **CIP 协议封装**：JS 模块完成协议打包/解析、IPID 注册握手、心跳保活（10s Ping）
- **深色/浅色主题**切换、低性能设备可关闭阴影与动画
- **无边框自绘窗口**：标题栏拖动、边缘缩放热区、窗口尺寸记忆
- **设置密码保护**（支持内置万能密码）、调试通道号与收发日志开关
- 持久化配置（QML `Settings`）：IP、端口、IPID、全屏、主题、密码等

## 程序架构

### 总体架构

```
┌─────────────────────────────────────────────────────────────┐
│                        TouchPad 应用                         │
├─────────────────────────────────────────────────────────────┤
│  UI 层（QML，qml/）                                          │
│   qml/Main.qml ─ 页面调度 / 标题栏 / 心跳 / 对话框           │
│   ├── pages/        业务页面（ConfigSelect / Connect / …）    │
│   ├── custom/       自定义控件（按钮 / 开关 / 音量条 …）      │
│   └── dialog/       对话框（密码 / 设置 / 确认 / 进程）       │
├─────────────────────────────────────────────────────────────┤
│  配置层（QML）                                               │
│   qml/config/  ConfigSet / ShiyiMZ / Haishi410 / MediaPlayer │
│   qml/Global.qml（QML 单例）：通道状态 + 主题 + 持久化设置    │
├─────────────────────────────────────────────────────────────┤
│  协议层（JS）                                                │
│   qml/js/crestroncip.js ── CIP 帧打包/解析、注册握手、心跳    │
├─────────────────────────────────────────────────────────────┤
│  网络层（C++，QML 单例）                                     │
│   src/network/TcpClient ── 生产模式：连接真实中控(QTcpSocket) │
│   src/network/TcpServer ── 演示模式：本机模拟中控(QTcpServer) │
├─────────────────────────────────────────────────────────────┤
│  入口（C++）                                                 │
│   src/main.cpp ── QGuiApplication + QQmlApplicationEngine    │
│              加载 TouchPad 模块的 Main 组件                   │
├─────────────────────────────────────────────────────────────┤
│  资源层（qrc，assets/）                                      │
│   assets/*/*.qrc ── icons / images / fonts（编译进程序）      │
└─────────────────────────────────────────────────────────────┘
                 │ TCP（CIP 协议，大端帧）
                 ▼
        Crestron 中控主机 / 模拟服务器
```

### 数据流

```
用户操作(QML 按钮等)
   │ 调用 crestroncip.js 的打包函数
   ▼
CIP 数据帧 (QByteArray)
   │ TcpClient.sendData()  ──── 生产模式
   │ TcpServer.sendData()  ──── 演示模式
   ▼
TCP 网络 ──► 中控 / 模拟服务器

中控返回数据
   ▼
TcpClient/TcpServer 发出 dataReceived 信号
   │ crestroncip.js 的 clientMessageCheck()/serverMessageCheck() 解析
   ▼
更新 Global.digital / Global.analog 等通道状态
   ▼
QML 属性绑定自动刷新界面
```

### 关键模块说明

| 模块 | 角色 |
| --- | --- |
| `src/main.cpp` | 程序入口。创建 QML 引擎并加载 `TouchPad` 模块的 `Main` 组件；设置组织名/应用名（供 `Settings` 持久化）与窗口图标。`TcpClient`/`TcpServer` 通过 `QML_SINGLETON` 由 QML 引擎自动创建 |
| `src/network/TcpClient` | TCP 客户端（生产模式）。`Q_INVOKABLE` 暴露 `connectToServer` / `sendData` / `disconnectFromServer`，以 `dataReceived` / `errorOccurred` / `stateChanged` 信号通知 QML |
| `src/network/TcpServer` | TCP 服务器（演示模式）。监听端口、IP 白名单校验、向所有客户端广播数据 |
| `qml/js/crestroncip.js` | CIP 协议封装。帧格式为 `[操作码][长度高][长度低][载荷...]`（大端），负责 IPID 注册、Join 状态同步、Ping/Pong 心跳、收发日志 |
| `qml/Global.qml` | QML 全局单例。缓存数字量/模拟量通道状态、主题配色与公共尺寸参数、全局字体，并通过 `Settings` 持久化应用设置（IP/端口/IPID/主题/密码/窗口尺寸等） |
| `qml/config/*.qml` | 场所配置文件（`ConfigSet` 启动页 / `ShiyiMZ` / `Haishi410` / `MediaPlayer`），声明该场所的背景、Logo、标题及页面布局（`CategoryType` 定义控件类型） |
| `qml/Main.qml` | 主窗口。根据"未选配置 → ConfigSelect；已选未连 → Connect；已连接 → ContentColumn/ContentRow"切换页面；承载全局对话框；负责 10s 心跳与 CIP 消息顶层分发 |
| `qml/pages/` | 业务页面：品牌设备控制页（`haishi/`、`shiyi/`）、媒体播放页（`mediaplayer/`）、连接页、内容布局与测试页 |
| `qml/custom/` | 自定义控件：`MyIconLabel`、`MySwitch`、`MyTabButton`、`VButton`、`VolumeBar`、`Output` 等 |
| `qml/dialog/` | 对话框：`PasswordDialog`（设置密码）、`SettingDialog`（系统设置）、`ConfirmDialog`（确认框）、`ProcessDialog`（进程框） |
| `assets/` | 静态资源：`icons/`、`images/`、`fonts/` 各自带一个 `.qrc`（`prefix` 分别为 `/icons`、`/images`、`/fonts`），编译进可执行文件 |

## 目录结构

```
TouchPad/
├── CMakeLists.txt               # 顶层构建脚本：可执行目标 + C++/资源 + 安装规则
│                                #   （QML 模块定义见 qml/CMakeLists.txt）
├── package.bat                  # Windows 打包脚本（windeployqt）
├── agent.md                     # QML / C++ 开发规范
├── README.md   LICENSE   .gitignore
│
├── src/                         # C++ 源码
│   ├── main.cpp                 # 入口（QGuiApplication + QQmlApplicationEngine）
│   └── network/                 # 网络层（注册为 QML 单例）
│       ├── TcpClient.cpp/.h     # TCP 客户端（生产模式）
│       └── TcpServer.cpp/.h     # TCP 服务器（演示模式）
│
├── qml/                         # QML 模块根目录（URI: TouchPad）
│   ├── CMakeLists.txt           # qt_add_qml_module 模块定义
│   ├── Main.qml                 # 主窗口（模块根组件）
│   ├── Global.qml               # QML 全局单例（状态/主题/设置）
│   ├── config/                  # 场所配置文件
│   │   ├── ConfigSet.qml        # 启动页（配置选择）
│   │   ├── ShiyiMZ.qml          # 市一医院 指挥中心会议室
│   │   ├── Haishi410.qml        # 海事大学 410 沉浸式教室
│   │   ├── MediaPlayer.qml      # 媒体播放器控制面板
│   │   └── CategoryType.qml     # 控件类型定义
│   ├── custom/                  # 自定义控件（按钮/开关/音量条/内容区 …）
│   ├── dialog/                  # 对话框（密码/设置/确认/进程）
│   ├── js/crestroncip.js        # Crestron CIP 协议封装
│   └── pages/                   # 业务页面
│       ├── ConfigSelect.qml     # 配置选择页
│       ├── Connect.qml          # 连接页
│       ├── ContentColumn.qml    # 内容布局（左侧竖排页签）
│       ├── ContentRow.qml       # 内容布局（底部横排页签）
│       ├── Test.qml             # 测试页
│       ├── haishi/              # 海诗设备控制页（Camera/LED/Remote/SingleScreen/VR）
│       ├── mediaplayer/         # 媒体播放页（Flash/MediaCamera/MediaSystem/Movie/
│       │                        #              Picture/PPT/Sound/Web）
│       └── shiyi/               # 世仪设备控制页（CameraControl/Light/Power/System/
│                                #                    Video/Volume）
│
├── assets/                      # 静态资源（各自 .qrc 编译进程序）
│   ├── icons/  + icons.qrc      # 图标       → qrc:/icons/…
│   ├── images/ + images.qrc     # 场所背景图 → qrc:/images/…
│   └── fonts/  + fonts.qrc      # 界面字体   → qrc:/fonts/…
│
├── android/                     # Android 打包资源（Manifest、Gradle、图标）
├── archive/                     # 未使用资源归档（不参与构建，见 archive/README.md）
└── build/                       # 构建输出目录（已 gitignore）
```

## 环境要求

- CMake ≥ 3.16
- Qt ≥ 6.10（组件：Quick，自带 Core/Gui/Qml 依赖）
- 编译器：MSVC（Windows，配合 windeployqt 打包）/ Clang（macOS）/ Android NDK（Android）

## 构建与运行

```bash
# 1. 配置（在项目根目录）
cmake -B build -DCMAKE_BUILD_TYPE=Release

# 2. 编译
cmake --build build --config Release

# 3. 运行（Windows 下可执行文件在 build/Release/TouchPad.exe）
```

本仓库当前实际使用 **MinGW Makefiles**（单配置生成器）+ Qt 6.11.2，
此时可执行文件位于 `build/TouchPad.exe`：

```powershell
$env:PATH = 'D:\Qt\Tools\mingw1310_64\bin;D:\Qt\6.11.2\mingw_64\bin;' + $env:PATH
cmake -S . -B build -G 'MinGW Makefiles' -DCMAKE_PREFIX_PATH=D:/Qt/6.11.2/mingw_64 `
  -DCMAKE_CXX_COMPILER=D:/Qt/Tools/mingw1310_64/bin/g++.exe `
  -DCMAKE_MAKE_PROGRAM=D:/Qt/Tools/mingw1310_64/bin/mingw32-make.exe
cmake --build build
```

### QML 模块目录布局（重要）

`qt_add_qml_module` 按「QML 文件相对 `qml/CMakeLists.txt` 所在目录的路径」
拼接出资源路径（前缀 `/qt/qml/` + 模块 URI `TouchPad`）：

| 源文件 | 资源路径 |
| --- | --- |
| `qml/Main.qml` | `:/qt/qml/TouchPad/Main.qml` |
| `qml/pages/haishi/LED.qml` | `:/qt/qml/TouchPad/pages/haishi/LED.qml` |

由此得出三条维护约束：

1. **模块定义必须位于 `qml/CMakeLists.txt`**。若在根 `CMakeLists.txt` 中直接写
   `qml/Main.qml`，资源会落到 `:/qt/qml/TouchPad/qml/Main.qml`，
   `loadFromModule("TouchPad", "Main")` 将找不到 `Main` 组件。
2. **QML 之间用相对 URL 互相引用**（`Main.qml` 的 `Loader.source`、`config/*.qml` 的
   `pageUrl`、`custom/*.qml` 的 `../js/crestroncip.js`）。调整目录层级时必须同步修正，
   否则错误只在运行期暴露。
3. **新增文件需登记**：QML 加入 `qml/CMakeLists.txt` 的 `QML_FILES`；
   静态资源加入 `assets/<类型>/<类型>.qrc`。

## 打包（Windows）

使用 `package.bat` 一键打包（需要 `windeployqt` 在 PATH 中）：

```bat
package.bat            :: 默认 Release
package.bat Debug      :: 指定配置
```

打包结果输出到 `output/` 目录，包含可执行文件及全部 Qt 依赖。

## 开发规范

QML 与 C++ 的编码规范见 [agent.md](agent.md)，主要包括：

- QML：对象属性顺序、强类型属性、声明式绑定优先、`qsTr()` 国际化、`required` 属性注入、不在 delegate 中存储状态等
- C++：Qt 6 优先、RAII、智能指针代替裸 new/delete、`enum class`、Qt 容器优先等

## 默认设置

| 设置项 | 默认值 |
| --- | --- |
| 中控 IP | 192.168.1.10 |
| 端口 | 41794 |
| IPID | 3 |
| 演示模式 | 关（演示模式下 127.0.0.1:41793） |
| 设置密码 | 123（内置万能密码：314159） |
| 主题 | 浅色 |

## 授权协议

本项目基于 [MIT License](LICENSE) 开源发布。

```
MIT License

Copyright (c) 2026 Zhuld
```

任何人可自由使用、复制、修改、合并、发布、分发、再许可及销售本软件，惟须在所有副本或主要部分中保留原始版权声明与许可声明。软件按"现状"提供，不附带任何形式的明示或暗示担保。

