import 'package:flutter/material.dart';
import 'package:smart_learn/app/style/appstyle.dart';

class WdgTextFeildCustom extends StatelessWidget {
  final String? hintText;
  final String? initValue;
  final Color? color;
  final FocusNode? focusNode;
  final int? maxLines;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
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
    final borderColor = color ?? context.style.color.primaryColor;

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
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5)),
        ),
      ),
      maxLines: maxLines,
    );
  }
}

InputDecoration inputDecoration({
  required BuildContext context,
  required String hintText,
  Color? color
}) => InputDecoration(
  labelText: hintText,
  labelStyle: const TextStyle(color: Colors.grey),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: color ?? context.style.color.primaryColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: color?.withAlpha(50) ?? context.style.color.primaryColor.withAlpha(50)),
  ),
);