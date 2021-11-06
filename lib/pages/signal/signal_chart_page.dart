import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_assistant/mixin/after_layout.dart';
import 'package:socket_assistant/pages/signal/signal_model.dart';
import 'package:socket_assistant/utils/socket_util.dart';
import 'package:sp_util/sp_util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SignalChartPage extends StatefulWidget {
  SignalChartPage({Key? key}) : super(key: key);

  @override
  _SignalChartPageState createState() => _SignalChartPageState();
}

class _SignalChartPageState extends State<SignalChartPage> with AfterLayoutMixin<SignalChartPage> {
  String host = '';
  int port = 0;
  bool isStart = false;
  List<SignalChartModel> _dataList = [];
  int _count = 0;
  bool canClear = true;

  void onReceiver(List<int> event) {
    try {
      var tempData = SignalChartModel.fromJson(json.decode(utf8.decode(event)));
      if ((tempData.x ?? 0) < 10 && canClear) {
        canClear = false;
        _dataList.clear();
        _count = 0;
      } else {
        _dataList.add(tempData);
        _count++;
        print(_count);
        if (_count > 100) canClear = true;
      }
      if (_count % 6 == 0) {
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
    }
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
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  height: width * 0.8,
                  child: SfCartesianChart(
                    primaryXAxis: NumericAxis(isVisible: false),
                    series: [
                      SplineSeries<SignalChartModel, int>(
                        dataSource: _dataList,
                        splineType: SplineType.monotonic,
                        xValueMapper: (SignalChartModel sales, _) => sales.x,
                        yValueMapper: (SignalChartModel sales, _) => sales.y,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => setState(() => _dataList.clear()),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF61bd79),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text('清除', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
