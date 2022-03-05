import 'package:flutter/material.dart';



InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.pink),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.pink),
      ),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.pink)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.grey, fontSize: 16);
}

TextStyle mediumTextStyle() {
  return TextStyle(color: Colors.pink, fontSize: 17);
}
