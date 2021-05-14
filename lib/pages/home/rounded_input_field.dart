import 'package:flutter/material.dart';
import 'package:socket_assistant/pages/home/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final void Function(String) onSubmitted;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
        cursorColor: Colors.grey,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.grey,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
