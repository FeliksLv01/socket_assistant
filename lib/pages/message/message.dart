import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_assistant/socket_manager.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String count = '';

  void onReceiver(List<int> event) {
    count = utf8.decode(event);
    debugPrint('useragreement listen :$event');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    SocketManage.mStream.listen(onReceiver);
  }

  @override
  void dispose() {
    SocketManage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Text(count),
      ),
    );
  }
}
