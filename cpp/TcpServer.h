#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QByteArray>
#include <QtQml/QtQml>

/**
 * @brief TCP 服务器封装类
 *
 * 以"服务器"身份监听端口，接收"客户端"连接（演示模式）：
 * 演示模式下由本应程序模拟中控服务器，同时也可配合中控厂家的
 * 平板 APP（如 Crestron App）进行联调。
 *
 * 通过 QML_ELEMENT/QML_SINGLETON 注册为 QML 单例，QML/JS 中直接以 TcpServer 访问。
 */
class TcpServer : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    explicit TcpServer(QObject *parent = nullptr);

    /// QML 单例创建函数：QML 引擎首次访问 TcpServer 类型时调用；
    /// 返回实例的所有权转移给 QML 引擎
    static TcpServer *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine);

    /// 在指定端口上启动监听；allowedIP 非空时只允许该 IP 的客户端接入
    Q_INVOKABLE void startServer(quint16 port, const QString &ipAddress);

    /// 关闭监听并断开所有客户端连接
    Q_INVOKABLE void stopServer();

    /// 向所有已连接客户端广播发送数据
    Q_INVOKABLE void sendData(const QByteArray &data);

signals:
    /// 有客户端建立连接（QML 借此发送服务器确认包 serverAccept）
    void clientConnected();
    // 说明：clientDisconnected 信号在 QML 端从未被监听（Main.qml 只处理 dataReceived/clientConnected），
    // 属于死代码，已删除声明；客户端断开的清理逻辑仍保留在 onClientDisconnected() 槽中。
    /// 收到客户端数据（QML 中交给 crestroncip.js 的 serverMessageCheck 解析）
    void dataReceived(const QByteArray &data);

private slots:
    /// 内部槽：处理新连接（IP 白名单校验、信号关联、加入客户端列表）
    void onNewConnection();
    /// 内部槽：客户端断开时将其从列表移除并销毁
    void onClientDisconnected();
    /// 内部槽：读取客户端数据并转发 dataReceived
    void onReadyRead();

private:
    QTcpServer *tcpServer;              ///< 底层监听服务器
    QList<QTcpSocket *> clients;        ///< 已连接的客户端列表
    QString allowedIPAddress;           ///< 允许接入的客户端 IP（空表示允许所有）
};

#endif // TCPSERVER_H
