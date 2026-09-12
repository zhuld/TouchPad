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
│  UI 层（QML）                                                │
│   Main.qml ─ 页面调度 / 标题栏 / 心跳 / 对话框                │
│   ├── Pages/        业务页面（ConfigSelect / Connect / …）     │
│   ├── Custom/       自定义控件（按钮 / 开关 / 音量条 …）       │
│   └── Dialog/       对话框（密码 / 设置 / 确认 / 进程）        │
├─────────────────────────────────────────────────────────────┤
│  配置层（QML）                                               │
│   Config/   ConfigSet / ShiyiMZ / Haishi410 / MediaPlayer    │
│   Global.qml（QML 单例）：通道状态缓存 + 主题 + 持久化设置     │
├─────────────────────────────────────────────────────────────┤
│  协议层（JS）                                                │
│   Js/crestroncip.js ── CIP 帧打包/解析、注册握手、心跳        │
├─────────────────────────────────────────────────────────────┤
│  网络层（C++，QML 单例）                                     │
│   cpp/TcpClient.cpp|.h ── 生产模式：连接真实中控（QTcpSocket）│
│   cpp/TcpServer.cpp|.h ── 演示模式：本机模拟中控（QTcpServer）│
├─────────────────────────────────────────────────────────────┤
│  入口（C++）                                                 │
│   main.cpp ── QGuiApplication + QQmlApplicationEngine        │
│              加载 TouchPad 模块的 Main 组件                   │
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
| `main.cpp` | 程序入口。创建 QML 引擎并加载 `TouchPad` 模块的 `Main` 组件；设置组织名/应用名（供 `Settings` 持久化）与窗口图标。`TcpClient`/`TcpServer` 通过 `QML_SINGLETON` 由 QML 引擎自动创建 |
| `cpp/TcpClient` | TCP 客户端（生产模式）。`Q_INVOKABLE` 暴露 `connectToServer` / `sendData` / `disconnectFromServer`，以 `dataReceived` / `errorOccurred` / `stateChanged` 信号通知 QML |
| `cpp/TcpServer` | TCP 服务器（演示模式）。监听端口、IP 白名单校验、向所有客户端广播数据 |
| `Js/crestroncip.js` | CIP 协议封装。帧格式为 `[操作码][长度高][长度低][载荷...]`（大端），负责 IPID 注册、Join 状态同步、Ping/Pong 心跳、收发日志 |
| `Global.qml` | QML 全局单例。缓存数字量/模拟量通道状态、主题配色与公共尺寸参数、全局字体，并通过 `Settings` 持久化应用设置（IP/端口/IPID/主题/密码/窗口尺寸等） |
| `Config/*.qml` | 场所配置文件（`ConfigSet` 启动页 / `ShiyiMZ` / `Haishi410` / `MediaPlayer`），声明该场所的背景、Logo、标题及页面布局（`CategoryType` 定义控件类型） |
| `Main.qml` | 主窗口。根据"未选配置 → ConfigSelect；已选未连 → Connect；已连接 → ContentColumn/ContentRow"切换页面；承载全局对话框；负责 10s 心跳与 CIP 消息顶层分发 |
| `Pages/` | 业务页面：品牌设备控制页（`Haishi/`、`Shiyi/`）、媒体播放页（`Mediaplayer/`）、连接页、内容布局与测试页 |
| `Custom/` | 自定义控件：`MyIconLabel`、`MySwitch`、`MyTabButton`、`VButton`、`VolumeBar`、`Output` 等 |
| `Dialog/` | 对话框：`PasswordDialog`（设置密码）、`SettingDialog`（系统设置）、`ConfirmDialog`（确认框）、`ProcessDialog`（进程框） |

## 目录结构

```
TouchPad/
├── main.cpp                 # C++ 入口
├── cpp/                     # C++ 网络层
│   ├── TcpClient.cpp/.h     # TCP 客户端（生产模式）
│   └── TcpServer.cpp/.h     # TCP 服务器（演示模式）
├── Main.qml                 # 主窗口（TouchPad 模块根组件）
├── Global.qml               # QML 全局单例（状态/主题/设置）
├── Config/                  # 场所配置文件
│   ├── ConfigSet.qml        # 启动页（配置选择）
│   ├── ShiyiMZ.qml          # 市一医院 指挥中心会议室
│   ├── Haishi410.qml        # 海事大学 410 沉浸式教室
│   ├── MediaPlayer.qml      # 媒体播放器控制面板
│   └── CategoryType.qml     # 控件类型定义
├── Pages/                   # 业务页面
│   ├── ConfigSelect.qml     # 配置选择页
│   ├── Connect.qml          # 连接页
│   ├── ContentColumn/Row.qml# 内容布局
│   ├── Test.qml             # 测试页
│   ├── Haishi/              # 海诗设备控制页（Camera/LED/Remote/SingleScreen/VR）
│   ├── Shiyi/               # 世仪设备控制页（CameraControl/Light/Power/System/Video/Volume）
│   └── Mediaplayer/         # 媒体播放页（Flash/MediaCamera/MediaSystem/Movie/Picture/PPT/Sound/Web）
├── Custom/                  # 自定义控件
├── Dialog/                  # 对话框
├── Js/crestroncip.js        # Crestron CIP 协议封装
├── icons/ images/ fonts/ sound/  # 静态资源（res.qrc 编译进程序）
├── res.qrc                  # Qt 资源文件
├── CMakeLists.txt           # 构建脚本（Qt 6.10+ / CMake 3.16+）
├── package.bat              # Windows 打包脚本（windeployqt）
├── agent.md                 # QML / C++ 开发规范
└── android/                 # Android 打包资源（Manifest、Gradle、图标）
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

