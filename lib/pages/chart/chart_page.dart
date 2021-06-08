import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_assistant/mixin/after_layout.dart';
import 'package:socket_assistant/utils/socket_util.dart';
import 'package:sp_util/sp_util.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ChartPage extends StatefulWidget {
  ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> with AfterLayoutMixin<ChartPage> {
  ValueNotifier<double> _angle = ValueNotifier<double>(0.0);
  String host = '';
  int port = 0;
  bool isStart = false;

  void onReceiver(List<int> event) {
    _angle.value = double.parse(utf8.decode(event));
    print(_angle.value);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: _angle,
                    builder: (context, value, child) {
                      double angle = value as double;
                      return Container(
                        width: width * 0.95,
                        height: width * 0.95,
                        child: SfRadialGauge(
                          animationDuration: 250,
                          axes: <RadialAxis>[
                            RadialAxis(
                                radiusFactor: 0.9,
                                interval: 15,
                                startAngle: 0,
                                endAngle: 360,
                                minimum: 0,
                                maximum: 360,
                                pointers: <GaugePointer>[
                                  NeedlePointer(value: angle)
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Text(
                                        '$angle',
                                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                      ),
                                      angle: 270,
                                      positionFactor: 0.5)
                                ])
                          ],
                        ),
                      );
                    })
              ],
            ),
            Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: width * 0.5,
                  width: width * 0.5,
                ),
                Text(
                  'CICC1255 木大木大团队',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  '某科学的声源定位识别器',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Spacer(),
                Row(
                  children: [
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
                    SizedBox(width: 20),
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
                  ],
                ),
                SizedBox(height: 40),
              ],
            )
          ],
        ),
      ),
    );
  }
}
