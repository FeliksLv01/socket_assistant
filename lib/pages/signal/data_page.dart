import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_assistant/mixin/after_layout.dart';
import 'package:socket_assistant/pages/signal/signal_model.dart';
import 'package:socket_assistant/utils/socket_util.dart';
import 'package:sp_util/sp_util.dart';

class SignalPage extends StatefulWidget {
  SignalPage({Key? key}) : super(key: key);

  @override
  _SignalPageState createState() => _SignalPageState();
}

class _SignalPageState extends State<SignalPage> with AfterLayoutMixin<SignalPage> {
  ValueNotifier<SignalModel> _data = ValueNotifier<SignalModel>(SignalModel(thd: 0, v0: 0, v1: 0, v2: 0, v3: 0, v4: 0));
  String host = '';
  int port = 0;
  bool isStart = false;

  void onReceiver(List<int> event) {
    try {
      var tempData = SignalModel.fromJson(json.decode(utf8.decode(event)));
      var currentModel = _data.value;
      if (currentModel != tempData) {
        _data.value = tempData;
        print(_data.value.toString());
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    host = SpUtil.getString("host")!;
    port = SpUtil.getInt("port")!;
  }

  @override
  void dispose() {
    SocketUtil.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void start() {
    if (!isStart) {
      isStart = true;
      Future.delayed(Duration.zero, () async {
        await SocketUtil.initSocket(host, port);
        SocketUtil.mStream.listen(onReceiver);
      });
    }
  }

  void stop() {
    isStart = false;
    SocketUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Spacer(),
              ValueListenableBuilder<SignalModel>(
                valueListenable: _data,
                builder: (context, model, _) {
                  return Text(
                    'THD: ${model.thd} \nV0: ${model.v0}\nV1: ${model.v1}\nV2: ${model.v2}\nV3: ${model.v3}\nV4: ${model.v4}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => start(),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF65B7F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text('开始', style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => stop(),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFF37370),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text('停止', style: TextStyle(fontSize: 20)),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
