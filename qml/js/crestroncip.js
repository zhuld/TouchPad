/**
 * @file qml/js/crestroncip.js
 * @brief Crestron SIMPL Windows 的 CIP 协议封装库（QML JS 模块）
 *
 * 负责在两套网络角色之间收发 CIP 协议数据帧：
 *   - 客户端角色（TcpClient）：连接真实中控，发送按键状态、查询设备状态；
 *   - 服务器角色（TcpServer）：演示模式下模拟中控，处理 App 的注册与指令。
 *
 * CIP 帧格式（大端）：
 *   [ 操作码 ][ 负载长度高8位 ][ 负载长度低8位 ][ 负载数据... ]
 *   帧间通过"操作码 + 长度"循环切分，支持一个数据包内含多帧。
 *
 * 通道号约定：外部（QML 配置/按钮）使用 1 基编号，协议内换算为 0 基：
 *   payload 中的通道 = 外部通道 - 1，且数字量通道低位在前（LOW = channel & 0xFF）。
 */

// ======================== CIP 操作码常量 ========================
const op_Server_Accept = 0x0F // 服务器接受连接 0F 00 01 02
const op_Client_IPID = 0x01 // 发送IPID 01 00 0B 00 00 00 00 00 XX 40 FF FF F1 01
const op_Server_IPID = 0x02 // 回复 02 00 04 00 00 00 1F ok; 02 00 03 FF FF 02 failed

const op_Join = 0x05 // 发送 Join信息
const op_Join_Digital = 0x00
const op_Join_Digital1 = 0x27
const op_Join_Analog = 0x14
// 说明：op_Join_Serial(=0x02) 与已注释的 op_Join_Analog1(=0x01) 在协议处理中从未被使用，
// 属于死代码，已删除。

const op_Join_Request = 0x03
const op_Join_Request_Reply_Start = 0x00
const op_Join_Request_Reply_Ending = 0x16
const op_Join_Request_Reply_Ended = 0x1C

const op_Join_DateTime = 0x08

const op_Client_Ping = 0x0D // 定时发送 0D 00 02 00 00
const op_Server_Pong = 0x0E // 回复 0E 00 02 00 00

/**
 * 客户端消息解析：处理从中控（服务器）收到的 CIP 数据。
 * 按帧结构循环切分，根据操作码更新 Global 中的设备状态，
 * 并在此完成 IPID 注册、设备状态查询（Join Request）等握手流程。
 */
function clientMessageCheck(message) {
    let index = 0
    //console.log("client: ", toHexString(message, " "))
    while (index < message.length) {
        let payloadType = message[index]
        let payloadLength = message[index + 2]
        let payload = message.slice(index + 3, index + 3 + payloadLength)
        switch (payloadType) {
        case op_Server_Accept:
            if (payload.length === 1 && payload[0] === 0x02) {
                recivedAppendList(message, index, payloadLength, "连接后，服务器确认")
                TcpClient.sendData(
                            cipmessage(
                                op_Client_IPID,
                                new Uint8Array([0x00, 0x00, 0x00, 0x00, 0x00, Global.settings.ipId, 0x40, 0xFF, 0xFF, 0xF1, 0x01])))
                sendAppendList(
                            cipmessageData(
                                op_Client_IPID,
                                new Uint8Array([0x00, 0x00, 0x00, 0x00, 0x00, Global.settings.demoMode ? Global.demoIPID : Global.settings.ipId, 0x40, 0xFF, 0xFF, 0xF1, 0x01])),
                            "发送IPID：" + Global.settings.demoMode ? Global.demoIPID : Global.settings.ipId + "，注册到服务器")
            }
            break
        case op_Server_IPID:
            if (toHexString(payload, "") === "0000001F" || toHexString(
                        payload, "") === "00000003") {
                recivedAppendList(
                            message, index, payloadLength,
                            "服务器确认IPID：" + Global.settings.demoMode ? Global.demoIPID : Global.settings.ipId + "，注册成功")
                TcpClient.sendData(
                            cipmessage(
                                op_Join,
                                new Uint8Array([0x00, 0x00, 0x02, op_Join_Request, 0x00])))
                sendAppendList(
                            cipmessageData(
                                op_Join,
                                new Uint8Array([0x00, 0x00, 0x02, op_Join_Request, 0x00])),
                            "发送查询指令")

                root.running = true //注册成功，转到控制页面
            } else if (toHexString(payload, "") === "FFFF02") {
                recivedAppendList(message, index, payloadLength, "服务器注册失败")
            }
            break
        case op_Join:
            //Join事件
            switch (payload[3]) {
            case op_Join_Digital:
            case op_Join_Digital1:
                //digital
                let channelD = payload[4] + (payload[5] & 0x7F) * 0x100 + 1
                if (isNaN(channelD) === false) {
                    let tmpD = Global.digital
                    tmpD[channelD] = !(payload[5] & 0x80)
                    Global.digital = tmpD
                }
                recivedAppendList(message, index, payloadLength,
                                  "Digital:" + channelD + " -> "
                                  + (Global.digital[channelD] ? "High" : "Low"))
                break
                //case op_Join_Analog1:
            case op_Join_Analog:
                //analog
                let channelA
                let tmpA = Global.analog
                if (payloadLength === 8) {
                    channelA = payload[4] * 0x100 + payload[5] + 1
                    if (isNaN(channelA) === false) {
                        tmpA[channelA] = payload[6] * 0x100 + payload[7]
                        Global.analog = tmpA
                    }
                } else if (payloadLength === 7) {
                    channelA = payload[4] + 1
                    if (isNaN(channelA) === false) {
                        tmpA[channelA] = payload[5] * 0x100 + payload[6]
                        Global.analog = tmpA
                    }
                }
                recivedAppendList(
                            message, index, payloadLength,
                            "Analog:" + channelA + " -> " + Global.analog[channelA])
                break
            case op_Join_Request:
                switch (payload[4]) {
                case op_Join_Request_Reply_Start:
                    recivedAppendList(message, index, payloadLength, "查询回复开始")
                    break
                case op_Join_Request_Reply_Ending:
                    recivedAppendList(message, index, payloadLength, "查询回复准备结束")
                    break
                case op_Join_Request_Reply_Ended:
                    recivedAppendList(message, index, payloadLength, "查询回复结束")
                    break
                default:
                    recivedAppendList(message, index, payloadLength, "查询回复其他事件")
                    break
                }
                break
            case op_Join_DateTime:
                const cipDate = Array.from(payload.slice(4),
                                           byte => byte.toString(16).padStart(
                                               2, '0')).join('')
                recivedAppendList(message, index, payloadLength, '中控时间：20'
                                  + cipDate.slice(12) + '/' + cipDate.slice(
                                      8, 10) + '/' + cipDate.slice(
                                      10, 12) + ' ' + cipDate.slice(
                                      2, 4) + ':' + cipDate.slice(
                                      4, 6) + ':' + cipDate.slice(6, 8))
                break
            default:
                recivedAppendList(message, index, payloadLength, "其他Join事件")
                break
            }
            break
        case op_Server_Pong:
            //console.log('pong')
            //recivedAppendList(message, index, payloadLength, "服务器回复Pong")
            break
        default:
            recivedAppendList(message, index, payloadLength, "其他未知事件")
            break
        }
        index = index + payloadLength + 3
    }
}

/**
 * 服务器消息解析（演示/模拟模式）：处理从客户端（平板 App）收到的 CIP 数据。
 * 负责校验 IPID、回复 Pong 心跳，并按客户端查询指令回放 initValue 初始状态：
 *   - digital：直接回发数字量状态；
 *   - digitalToggle：只标记开关锁定，由 digital 分支按锁定状态回发；
 *   - analog：将配置的模拟量初值反向发送给客户端。
 */
function serverMessageCheck(message) {
    let index = 0
    //console.log("server: ", toHexString(message, " "))
    while (index < message.length) {
        let payloadType = message[index]
        let payloadLength = message[index + 2]
        let payload = message.slice(index + 3, index + 3 + payloadLength)
        switch (payloadType) {
        case op_Client_IPID:
            // 收到IPID信息
            if (payloadLength === 11 & payload[5] === Global.settings.ipId) {
                TcpServer.sendData(
                            cipmessage(
                                op_Server_IPID,
                                new Uint8Array([0x00, 0x00, 0x00, 0x1F]))) //0000001F
            } else {
                TcpServer.sendData(cipmessage(
                                       op_Server_IPID,
                                       new Uint8Array([0xFF, 0xFF, 0x02])))
            }
            break
        case op_Client_Ping:
            // 收到ping，回复pong
            if (payloadLength === 2) {
                pong()
            }
            break
        case op_Join:
            // 收到Join查询指令，
            switch (payload[3]) {
            case op_Join_Request:
                //Todo:处理查询指令
                TcpServer.sendData(
                            cipmessage(
                                op_Join,
                                new Uint8Array([0x00, 0x00, 0x02, op_Join_Request, op_Join_Request_Reply_Start])))
                for (var i = 0; i
                     < Global.configList[Global.settings.configSetting].initValue.count; i++) {
                    let item = Global.configList[Global.settings.configSetting].initValue.get(
                            i)
                    //console.log(item.name, item.channel, item.value)
                    switch (item.name) {
                    case "digital":
                        if (item.value !== 0) {
                            TcpServer.sendData(
                                        cipmessage(
                                            op_Join,
                                            new Uint8Array([0x00, 0x00, 0x03, op_Join_Digital, item.channel - 1 % 0x100, item.channel / 0x100])))
                        }
                        break
                    case "digitalToggle":
                        if (item.value !== 0) {
                            Global.digitalToggle[item.channel] = true
                        }
                        break
                    case "analog":
                        TcpClient.sendData(
                                    cipmessage(
                                        op_Join,
                                        new Uint8Array([0x00, 0x00, 0x05, op_Join_Analog, item.channel / 0x100, item.channel - 1 % 0x100, item.value / 0x100, item.value % 0x100])))
                        break
                    }
                }

                TcpServer.sendData(
                            cipmessage(
                                op_Join,
                                new Uint8Array([0x00, 0x00, 0x02, op_Join_Request, op_Join_Request_Reply_Ending])))

                TcpServer.sendData(
                            cipmessage(
                                op_Join,
                                new Uint8Array([0x00, 0x00, 0x02, op_Join_Request, op_Join_Request_Reply_Ended])))
                break
            case op_Join_Digital:
            case op_Join_Digital1:

                //digital
                if (Global.digitalToggle[payload[4] + 1]) {
                    if (payload[5] === 0) {
                        if (Global.digital[payload[4] + 1]) {
                            payload[5] = 128
                        } else {
                            payload[5] = 0
                        }
                        TcpServer.sendData(cipmessage(op_Join, payload))
                    }
                } else {
                    TcpServer.sendData(cipmessage(op_Join, payload))
                }

                break
                //case op_Join_Analog1:
            case op_Join_Analog:
                if (payloadLength === 8) {
                    TcpServer.sendData(
                                cipmessage(
                                    op_Join,
                                    new Uint8Array([0x00, 0x00, 0x05, payload[3], message[4], payload[5], payload[6], payload[7]])))
                }
                break
            }
            break
        }
        index = index + payloadLength + 3
    }
}

/**
 * 将操作码与负载打包成带 3 字节帧头的 CIP 数据（ArrayBuffer，供 TcpClient/TcpServer 发送）。
 */
function cipmessage(opCode, message) {
    return cipmessageData(opCode, message).buffer
}

/**
 * 将操作码与负载打包成带 3 字节帧头的 Uint8Array（便于日志打印）。
 * 帧头 = [opCode, 长度高字节, 长度低字节]，负载从第 4 字节开始。
 */
function cipmessageData(opCode, message) {
    let m = new Uint8Array(message.length + 3)
    m[0] = opCode
    m[1] = message.length / 0x100
    m[2] = message.length % 0x100
    m.set(message, 3)
    return m
}

// ============ 客户端对外操作（按钮按下/松开调用） ============

/**
 * 按下数字量通道（Press）：向中控发送 Digital 高电平脉冲按下信号。
 * 注意：协议中通道号为 0 基，因此这里做了 -1 换算。
 */
//client
function push(channel) {
    if (channel > 0 & channel < 32767) {
        channel = channel - 1
        TcpClient.sendData(
                    cipmessage(
                        op_Join,
                        new Uint8Array([0x00, 0x00, 0x03, op_Join_Digital, channel
                                        % 0x100, channel / 0x100])))
        sendAppendList(
                    cipmessageData(
                        op_Join,
                        new Uint8Array([0x00, 0x00, 0x03, op_Join_Digital, channel
                                        % 0x100, channel / 0x100])),
                    "Digital:" + (channel + 1) + " -> " + "Push")
    }
}
/**
 * 松开数字量通道（Release）：向中控发送 Digital 低电平（最高位置 1 表示松开）。
 */
function release(channel) {
    if (channel > 0 & channel < 32767) {
        channel = channel - 1
        TcpClient.sendData(
                    cipmessage(
                        op_Join,
                        new Uint8Array([0x00, 0x00, 0x03, op_Join_Digital, channel
                                        % 0x100, (channel / 0x100) | 0x80])))
        sendAppendList(
                    cipmessageData(
                        op_Join,
                        new Uint8Array([0x00, 0x00, 0x03, op_Join_Digital, channel
                                        % 0x100, channel / 0x100 | 0x80])),
                    "Digital:" + (channel + 1) + " -> " + "Release")
    }
}
/**
 * 设置模拟量通道值（如音量、亮度）：value 范围 0~65535。
 * 先发高位再发低位（大端序）。
 */
function level(channel, value) {
    if (channel > 0 & channel < 65536) {
        channel = channel - 1
        TcpClient.sendData(
                    cipmessage(
                        op_Join,
                        new Uint8Array([0x00, 0x00, 0x05, op_Join_Analog, channel / 0x100, channel
                                        % 0x100, value / 0x100, value % 0x100])))
        sendAppendList(
                    cipmessageData(
                        op_Join,
                        new Uint8Array([0x00, 0x00, 0x05, op_Join_Analog, channel / 0x100, channel
                                        % 0x100, value / 0x100, value % 0x100])),
                    "Analog:" + (channel + 1) + " -> " + value)
    }
}
/**
 * 发送心跳 Ping：由 Main.qml 的定时器周期调用，防止中控判定本端离线。
 */
function ping() {
    TcpClient.sendData(cipmessage(op_Client_Ping, new Uint8Array([0x00, 0x00])))
}

// ============ 服务器对外操作（演示模式） ============

/// 回复客户端 Pong，维持心跳会话
//Server
function pong() {
    TcpServer.sendData(cipmessage(op_Server_Pong, new Uint8Array([0x00, 0x00])))
}

/// 向客户端发送"服务器接受连接"确认包
function serverAccept() {
    TcpServer.sendData(cipmessage(op_Server_Accept, new Uint8Array([0x02])))
}

/// 将字节数组转为大写十六进制字符串，space 指定字节间的分隔符（如 " " 或 ""）
function toHexString(data, space) {
    let hexMessage = ""
    let s = space
    for (var i = 0; i < data.length; i++) {
        let hex = data[i].toString(16)
        // 将字节转换为十六进制
        if (hex.length < 2) {
            hex = "0" + hex // 补齐两位
        }
        hexMessage += hex
        hexMessage += s
    }
    return hexMessage.toUpperCase()
}

/// 调试日志：记录"接收"帧（showChannel 开启时输出时间戳 + 十六进制数据 + 说明）
function recivedAppendList(message, index, payloadLength, detail) {
    if (Global.settings.showChannel) {
        console.log("[RX]", new Date().toLocaleTimeString(
                        Qt.locale("zh_CN"), " hh:mm:ss"), toHexString(
                        message.slice(index,
                                      index + 3 + payloadLength), " "), detail)
    }
}

/// 调试日志：记录"发送"帧（showChannel 开启时输出时间戳 + 十六进制数据 + 说明）
function sendAppendList(data, detail) {
    if (Global.settings.showChannel) {
        console.log('[TX]', new Date().toLocaleTimeString(Qt.locale("zh_CN"),
                                                          " hh:mm:ss"),
                    toHexString(data, " "), detail)
    }
}
