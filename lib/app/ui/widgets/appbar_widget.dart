import 'package:flutter/material.dart';

class WIDAppBar {
  static Widget leadingDefault(BuildContext context) => IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.design_services)
  );
}