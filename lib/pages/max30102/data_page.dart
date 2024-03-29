import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_assistant/mixin/after_layout.dart';
import 'package:socket_assistant/pages/max30102/model.dart';
import 'package:socket_assistant/utils/socket_util.dart';
import 'package:sp_util/sp_util.dart';

class DataPage extends StatefulWidget {
  DataPage({Key? key}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> with AfterLayoutMixin<DataPage> {
  ValueNotifier<Max30102Model> _data = ValueNotifier<Max30102Model>(Max30102Model(hrAvg: 0, spo2Avg: 0));
  String host = '';
  int port = 0;
  bool isStart = false;

  void onReceiver(List<int> event) {
    try {
      var tempData = Max30102Model.fromJson(json.decode(utf8.decode(event)));
      var currentModel = _data.value;
      if (currentModel != tempData) {
        _data.value = tempData;
        print(_data.value.toJson());
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
              ValueListenableBuilder<Max30102Model>(
                valueListenable: _data,
                builder: (context, model, _) {
                  return Text(
                    '心率: ${model.hrAvg} \n血氧: ${model.spo2Avg}',
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
