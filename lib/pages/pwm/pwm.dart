import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_assistant/mixin/after_layout.dart';
import 'package:socket_assistant/utils/socket_util.dart';
import 'package:sp_util/sp_util.dart';

class PWMPage extends StatefulWidget {
  PWMPage({Key? key}) : super(key: key);

  @override
  _PWMPageState createState() => _PWMPageState();
}

class _PWMPageState extends State<PWMPage> with AfterLayoutMixin<PWMPage> {
  double _sliderValue = 0.5;
  String _percentValue = '50';

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      String host = SpUtil.getString("host")!;
      int port = SpUtil.getInt("port")!;
      await SocketUtil.initSocket(host, port);
    });
  }

  @override
  void dispose() {
    SocketUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backwardsCompatibility: false,
        title: Text('调节占空比', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'assets/images/8266.png',
                height: 200,
                width: 200,
              ),
            ),
            Text(
              '当前占空比：$_percentValue%',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: CupertinoSlider(
                activeColor: Color(0xFF47c7dc),
                value: _sliderValue,
                onChanged: (v) {
                  setState(() {
                    _sliderValue = v;
                    _percentValue = (_sliderValue * 100).toStringAsFixed(1);
                  });
                },
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                SocketUtil.mSocket.write('$_percentValue%');
                print('发送 ====> : $_percentValue%');
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF47c7dc),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text('确认修改', style: TextStyle(fontSize: 20)),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
