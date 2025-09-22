import 'package:flutter/material.dart';

class WdgDivider extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const WdgDivider({
    super.key,
    this.height,
    this.width,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: height ?? 6,
        width: width ?? MediaQuery.of(context).size.width,
        color: color ?? Colors.grey.withAlpha(20),
      ),
    );
  }
}