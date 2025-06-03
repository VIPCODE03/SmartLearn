import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {String message = 'Đang tạo dữ liệu...'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    ),
  );
}
