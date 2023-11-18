import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlert(BuildContext context, String title, String subtitle) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: [
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Ok'),
                )
              ],
            ));
  }

  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ]));
}
