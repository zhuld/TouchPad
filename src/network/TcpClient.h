#ifndef TCPCLIENT_H
#define TCPCLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QString>
#include <QtQml/QtQml>

/**
 * @brief TCP 客户端封装类
 *
 * 以"客户端"身份主动连接中控服务器（生产模式），
 * 作为 QML 与 Crestron 中控之间收发 CIP 协议数据的桥梁。
 * 通过 QML_ELEMENT/QML_SINGLETON 注册为 QML 单例，QML/JS 中直接以 TcpClient 访问。
 */
class TcpClient : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit TcpClient(QObject *parent = nullptr);

    /// QML 单例创建函数：QML 引擎首次访问 TcpClient 类型时调用；
    /// 返回实例的所有权转移给 QML 引擎
    static TcpClient *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine);

    // —— 以下方法通过 Q_INVOKABLE 暴露给 QML 直接调用 ——

    /// 连接中控服务器；若已处于连接中则忽略本次调用
    Q_INVOKABLE void connectToServer(const QString &host, quint16 port);

    /// 发送原始数据帧（CIP 帧由 crestroncip.js 打包后传入）
    Q_INVOKABLE void sendData(const QByteArray &data);

    /// 主动断开与服务器的连接
    Q_INVOKABLE void disconnectFromServer();

signals:
    /// 收到服务器数据（QML 中交给 crestroncip.js 的 clientMessageCheck 解析）
    void dataReceived(const QByteArray &data);
    /// 连接出错（errorString，QML 连接页面用于提示）
    void errorOccurred(const QString &error);
    // 状态改变信号：state == 0(UnconnectedState) 时表示连接断开，
    // QML 中据此切换回连接页面（仅此信号被 QML 监听，connected/disconnected 已移除）
    void stateChanged(QAbstractSocket::SocketState state);

private slots:
    /// 内部槽：socket 可读时读取全部数据并转发 dataReceived
    void onReadyRead();
    /// 内部槽：socket 出错时转发 errorOccurred
    void onError(QAbstractSocket::SocketError socketError);
    /// 内部槽：socket 状态变化时转发 stateChanged
    void onStateChanged(QAbstractSocket::SocketState state);

private:
    QTcpSocket *tcpSocket;   ///< 底层 TCP socket
    QString currentHost;     ///< 最近一次连接的目标地址（IPv4）
    quint16 currentPort;     ///< 最近一次连接的目标端口
};
#endif // TCPCLIENT_H
