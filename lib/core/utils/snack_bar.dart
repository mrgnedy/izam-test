import 'package:daftra/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  const AppSnackBar._();

  static show(BuildContext context, {required bool isError, required String message}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if(isError)
            Icon(Icons.cancel, color: Colors.red[600])
            else
            Icon(Icons.check_circle, color: Colors.green[600]),
            8.hPad,
            Text(message)
          ],
        ),
      ),
    );
  }
}
