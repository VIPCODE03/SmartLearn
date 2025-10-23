import 'package:flutter/material.dart';
import 'package:smart_learn/app/style/appstyle.dart';

class WdgItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  const WdgItem({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: onTap,
            backgroundColor: context.style.color.primaryColor.withValues(alpha: 0.7),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
        ],
    );
  }
}
