import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

import 'pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Assistant',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF3F4F6),
        appBarTheme: AppBarTheme(
          color: Color(0xFFF3F4F6),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
