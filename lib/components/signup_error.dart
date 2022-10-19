import 'package:flutter/material.dart';
import 'package:sqq_flutter2/constants.dart';


class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

    static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(content: Text(text), backgroundColor: kRedColor);
    messengerKey.currentState!
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
  }
}