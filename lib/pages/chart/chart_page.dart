import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_assistant/socket_manager.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ChartPage extends StatefulWidget {
  ChartPage({Key key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  double angle = 0.0;

  void onReceiver(List<int> event) {
    angle = double.parse(utf8.decode(event));
    print(angle);
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
        centerTitle: true,
        title: Text('测试', style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF47c7dc),
        onPressed: () async {
          SocketManage.dispose();
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_rounded),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$angle',
              style: TextStyle(fontSize: 20),
            ),
            SfRadialGauge(
              animationDuration: 250,
              axes: <RadialAxis>[
                RadialAxis(
                  radiusFactor: 0.9,
                  interval: 15,
                  startAngle: 0,
                  endAngle: 360,
                  minimum: 0,
                  maximum: 360,
                  pointers: <GaugePointer>[NeedlePointer(value: angle)],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
