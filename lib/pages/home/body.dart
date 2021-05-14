import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socket_assistant/pages/chart/chart_page.dart';
import 'package:socket_assistant/socket_manager.dart';
import 'package:socket_assistant/pages/home/rounded_input_field.dart';

class Body extends StatelessWidget {
  Body({Key key}) : super(key: key);

  final hostController = new TextEditingController();
  final portController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SvgPicture.asset(
              'assets/images/cloud.svg',
              height: 128,
              width: 128,
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
              String host = hostController.text;
              int port = int.parse(portController.text);
              await SocketManage.initSocket(host, port);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChartPage();
                }),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF47c7dc),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text('开始连接', style: TextStyle(fontSize: 20)),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
