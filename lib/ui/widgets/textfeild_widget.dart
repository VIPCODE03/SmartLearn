import 'package:flutter/material.dart';

import '../../global.dart';

class WdgTextFeildCustom extends StatelessWidget {
  final String? hintText;
  final String? initValue;
  final Color? color;
  final FocusNode? focusNode;
  final int? maxLines;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final TextEditingController? controller;

  const WdgTextFeildCustom({
    super.key,
    this.hintText,
    this.initValue,
    this.focusNode,
    this.color,
    this.maxLines,
    this.validator,
    this.onChanged,
    this.controller
  });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      initialValue: initValue,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color ?? primaryColor(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color?.withAlpha(50) ?? primaryColor(context).withAlpha(50)),
        ),
      ),
      maxLines: maxLines,
    );
  }
}