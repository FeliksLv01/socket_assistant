import 'dart:io';
import 'dart:async';

class SocketUtil {
  static late Socket mSocket;
  static late Stream<List<int>> mStream;

  static Future<void> initSocket(String host, int port) async {
    await Socket.connect(host, port).then((Socket socket) {
      mSocket = socket;
      mStream = mSocket.asBroadcastStream(); //多次订阅的流 如果直接用socket.listen只能订阅一次
      print('connection established');
    }).catchError((e) {
      print('connectException:$e');
      initSocket(host, port);
    });
  }

  static void addParams(List<int> params) {
    mSocket.add(params);
  }

  static void dispose() {
    mSocket.destroy();
    print("connection close");
  }

  /// 判断是否可以连接
  static Future<bool> isHostConnectable(String host, int port) async {
    bool isOk = false;
    await Socket.connect(host, port, timeout: Duration(seconds: 5)).then((socket) {
      socket.destroy();
      isOk = true;
    }).catchError((e) {
      print('connectException:$e');
    });

    return isOk;
  }
}
