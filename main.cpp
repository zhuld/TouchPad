/**
 * @file main.cpp
 * @brief TouchPad 应用程序入口
 *
 * 功能概览：
 *   1. 创建 QML 引擎并加载 TouchPad 模块（Main.qml 为主窗口）；
 *   2. C++ 网络层 TcpClient / TcpServer 通过 QML_ELEMENT/QML_SINGLETON 注册为
 *      QML 单例（类型名 TcpClient / TcpServer），由 QML 引擎自动创建，
 *      供 QML 直接调用收发 Crestron CIP 协议数据；
 *   3. 配置应用标识（组织名/应用名），用于 QML Settings 持久化保存路径。
 *
 * 网络架构说明：
 *   - TcpClient：以"客户端"身份连接真正的 Crestron 中控（生产模式）；
 *   - TcpServer：在"演示模式"下模拟中控服务端角色。
 */
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // QML 引擎创建主界面对象失败时退出程序（避免黑屏挂死）
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // 说明：C++ 网络层已通过 QML_SINGLETON 注册为单例（TcpClient / TcpServer），
    // 由 QML 引擎在首次访问时自动创建，这里无需再注入全局对象。

    // 设置应用标识：QML 的 Settings 据此生成持久化配置文件
    app.setOrganizationName("Zhuld");     // 公司/组织名
    app.setOrganizationDomain("zld.com"); // 组织域名
    app.setApplicationName("TouchPad");   // 应用名

    // 窗口/任务栏图标（control.png 编译进 qrc 资源）
    app.setWindowIcon(QIcon(":/icons/control.png"));

    // 加载 QML 模块 TouchPad 的根组件 Main（见 CMakeLists.txt 中 qt_add_qml_module 定义）
    engine.loadFromModule("TouchPad", "Main");

    return QCoreApplication::exec();
}

