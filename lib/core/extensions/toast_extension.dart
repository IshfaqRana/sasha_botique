import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';

extension BuildContextEntension<T> on BuildContext {
  Future<bool?> showToast(String message) {
// It's a plugin to show toast and we can with extension
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: colors.primary,
      textColor: colors.textColor,
    );
  }
}