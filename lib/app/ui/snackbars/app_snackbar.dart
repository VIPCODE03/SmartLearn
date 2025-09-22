import 'package:flutter/material.dart';

enum SnackbarType { error, success, normal }

void showAppSnackbar(
    BuildContext context,
    String message, {
      SnackbarType type = SnackbarType.normal,
    }) {
  Color backgroundColor;

  switch (type) {
    case SnackbarType.error:
      backgroundColor = Colors.red;
      break;
    case SnackbarType.success:
      backgroundColor = Colors.green;
      break;
    case SnackbarType.normal:
      backgroundColor = Colors.grey;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 1),
    ),
  );
}
