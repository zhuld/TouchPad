#include "TcpClient.h"
#include <QHostAddress>

TcpClient::TcpClient(QObject *parent) : QObject(parent)
{
    tcpSocket = new QTcpSocket(this);

    // 关联 socket 内部信号与转发槽（QXmpp 风格：内部消化，对外只暴露自定义信号）
    connect(tcpSocket, &QTcpSocket::readyRead, this, &TcpClient::onReadyRead);
    // connected/disconnected 已有 stateChanged 信号覆盖（QML 端只监听 stateChanged），
    // 因此删除这两个信号的转发，避免死代码。
    connect(tcpSocket, &QTcpSocket::errorOccurred, this, &TcpClient::onError);
    connect(tcpSocket, &QTcpSocket::stateChanged, this, &TcpClient::onStateChanged);
}

TcpClient *TcpClient::create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    Q_UNUSED(jsEngine)
    // 所有权转移给 QML 引擎，由引擎统一销毁
    return new TcpClient();
}

void TcpClient::connectToServer(const QString &host, quint16 port)
{
    currentHost = host;
    currentPort = port;

    // 仅在完全断开状态下发起连接，避免重复连接
    if (tcpSocket->state() == QTcpSocket::UnconnectedState) {
        tcpSocket->connectToHost(QHostAddress(currentHost), currentPort);
    }
}

void TcpClient::sendData(const QByteArray &data)
{
    // 只发送非空数据，且仅在已连接状态下写入
    if(data.toHex()!=""){
        if (tcpSocket->state() == QTcpSocket::ConnectedState) {
            tcpSocket->write(data);
            tcpSocket->flush(); // 立即发送，避免积压在系统缓冲区
        }
        //qDebug() << "Data send to server:" << data.toHex(); // 调试用：打印发送的十六进制数据
    }
}

void TcpClient::disconnectFromServer()
{
    // 主动关闭连接（状态变为 UnconnectedState 后 QML 会收到 stateChanged 通知）
    tcpSocket->disconnectFromHost();
}

// 说明：checkState() 原实现只是获取状态并丢弃返回值，且从未被 QML 调用，属于死代码，已删除。
// 如需获取状态，QML 可直接监听 onStateChanged 信号。

void TcpClient::onReadyRead()
{
    // 一次性读取缓冲区中所有数据，减少信号触发次数
    QByteArray data = tcpSocket->readAll();
    emit dataReceived(data);
}

void TcpClient::onError(QAbstractSocket::SocketError socketError)
{
    // 将 Qt 的枚举错误转为可读字符串交由 QML 显示
    Q_UNUSED(socketError);
    emit errorOccurred(tcpSocket->errorString());
}

void TcpClient::onStateChanged(QAbstractSocket::SocketState state)
{
    emit stateChanged(state);  // 转发自定义状态改变信号给 QML
}
