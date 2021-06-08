import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_assistant/pages/chart/chart_page.dart';
import 'package:socket_assistant/utils/socket_util.dart';
import 'package:socket_assistant/pages/home/rounded_input_field.dart';
import 'package:sp_util/sp_util.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final hostController = new TextEditingController();
  final portController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    hostController.text = SpUtil.getString("host") ?? '';
    int port = SpUtil.getInt("port") ?? 0;
    portController.text = port == 0 ? '' : port.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Image.asset(
              'assets/images/logo.png',
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
          RoundedInputField(
            icon: Icons.wifi_outlined,
            hintText: 'IP地址',
            controller: hostController,
          ),
          RoundedInputField(
            icon: Icons.location_on_outlined,
            hintText: '端口',
            controller: portController,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                String host = hostController.text;
                int port = int.parse(portController.text);
                bool isOk = await SocketUtil.isHostConnectable(host, port);
                if (isOk) {
                  SpUtil.putString("host", host);
                  SpUtil.putInt("port", port);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChartPage()));
                } else {
                  showError(context);
                }
              } catch (e) {
                showError(context);
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF47c7dc),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text('确认', style: TextStyle(fontSize: 20)),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  void showError(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('连接失败', style: TextStyle(fontSize: 20)),
          content: Text('请重新输入'),
          actions: [
            CupertinoDialogAction(
              child: Text('确认'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
