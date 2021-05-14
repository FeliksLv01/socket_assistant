import 'dart:io';
import 'dart:async';

class SocketManage {
  static Socket mSocket;
  static Stream<List<int>> mStream;

  static Future<void> initSocket(String host, int port) async {
    await Socket.connect(host, port).then((Socket socket) {
      mSocket = socket;
      mStream = mSocket.asBroadcastStream(); //多次订阅的流 如果直接用socket.listen只能订阅一次
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
  }
}
