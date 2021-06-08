/*
 * @Author: kcqnly 
 * @Date: 2021-06-07 13:14:40 
 * @Last Modified by: kcqnly
 * @Last Modified time: 2021-06-07 13:15:03
 * @Message: 用于监听frame绘制完成
 */
import 'package:flutter/widgets.dart';

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context);
}
