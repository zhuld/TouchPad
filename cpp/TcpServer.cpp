#include "TcpServer.h"
#include <QHostAddress>

TcpServer::TcpServer(QObject *parent) : QObject(parent)
{
    tcpServer = new QTcpServer(this);

    // 当有新连接时，QTcpServer 会发射 newConnection() 信号
    connect(tcpServer, &QTcpServer::newConnection, this, &TcpServer::onNewConnection);
}

TcpServer *TcpServer::create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    Q_UNUSED(jsEngine)
    // 所有权转移给 QML 引擎，由引擎统一销毁
    return new TcpServer();
}

void TcpServer::startServer(quint16 port, const QString &ipAddress)
{
    // 启动服务器监听指定端口（0.0.0.0 监听全部网卡）
    if (tcpServer->listen(QHostAddress::Any, port)) {
        //qDebug() << "Server started on port" << port;
    } else {
        //qDebug() << "Server failed to start:" << tcpServer->errorString();
    }
    allowedIPAddress = ipAddress; // 保存白名单 IP，供 onNewConnection 使用
}

void TcpServer::stopServer()
{
    // 先关闭所有存量客户端连接
    for (QTcpSocket *clientSocket : std::as_const(clients)) {
        if (clientSocket->state() == QAbstractSocket::ConnectedState) {
            clientSocket->close();
        }
    }
    // 再关闭监听端口
    if(tcpServer->isListening()){
        tcpServer->close();
    }
}

void TcpServer::onNewConnection()
{
    // 接受新客户端连接
    QTcpSocket *clientSocket = tcpServer->nextPendingConnection();

    // 获取客户端 IP 地址
    QString clientIP = clientSocket->peerAddress().toString();
    // 检查是否是 IPv6 格式的 IPv4 地址 (::ffff:xxx.xxx.xxx.xxx)
    if (clientIP.startsWith("::ffff:")) {
        // 提取 IPv4 地址
        clientIP = clientIP.mid(7);
    }
    // 检查客户端 IP 地址是否匹配允许的 IP 地址（IP 白名单机制）
    if (!allowedIPAddress.isEmpty() && clientIP != allowedIPAddress) {
        //qDebug() << "Connection from IP" << clientIP << "rejected. Allowed IP is:" << allowedIPAddress;
        clientSocket->disconnectFromHost();  // 拒绝连接
        return;  // 直接返回，不处理这个连接
    }

    // 关联该客户端的信号：断开清理 + 数据转发
    connect(clientSocket, &QTcpSocket::disconnected, this, &TcpServer::onClientDisconnected);
    connect(clientSocket, &QTcpSocket::readyRead, this, &TcpServer::onReadyRead);

    clients.append(clientSocket); // 加入连接列表，便于统一管理/广播
    emit clientConnected();       // 通知 QML 有新客户端接入
    //qDebug() << "Client connected!";
}

void TcpServer::onClientDisconnected()
{
    QTcpSocket *clientSocket = qobject_cast<QTcpSocket *>(sender());

    if (clientSocket) {
        clients.removeAll(clientSocket); // 从列表移除
        clientSocket->deleteLater();     // 延迟销毁 socket 对象
        // 说明：原 emit clientDisconnected() 在 QML 端无任何监听，属死代码，已删除。
        // 仅保留必要的客户端清理工作。
    }
}

void TcpServer::onReadyRead()
{
    QTcpSocket *clientSocket = qobject_cast<QTcpSocket *>(sender());

    if (clientSocket) {
        // 读取客户端发送的数据
        QByteArray data = clientSocket->readAll();
        //qDebug() << "Data received from client:" << data.toHex();  // 调试用：以十六进制显示

        // 发射信号，以便外部（QML 协议解析）处理
        emit dataReceived(data);
    }
}

void TcpServer::sendData(const QByteArray &data)
{
    // 遍历所有已连接的客户端并广播发送数据
    for (QTcpSocket *clientSocket : std::as_const(clients)) {
        if (clientSocket->state() == QAbstractSocket::ConnectedState) {
            clientSocket->write(data);
            clientSocket->flush();  // 确保数据立即发送
            //qDebug() << "Data sent to client:" << data.toHex();  // 调试用
        }
    }
}
