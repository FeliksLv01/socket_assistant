import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_assistant/pages/home/body.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

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
        '串口助手',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
