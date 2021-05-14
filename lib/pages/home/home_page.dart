import 'package:flutter/material.dart';
import 'package:socket_assistant/pages/home/body.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
      title: Text(
        '连接服务器',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
