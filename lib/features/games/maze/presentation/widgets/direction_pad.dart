import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class DirectionPad extends StatelessWidget {
  final void Function(Direction direction) onDirectionChanged;

  const DirectionPad({super.key, required this.onDirectionChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 50,
            child: _DirectionButton(
              icon: Icons.keyboard_arrow_up,
              onTap: () => onDirectionChanged(Direction.up),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 50,
            child: _DirectionButton(
              icon: Icons.keyboard_arrow_down,
              onTap: () => onDirectionChanged(Direction.down),
            ),
          ),
          Positioned(
            left: 0,
            top: 50,
            child: _DirectionButton(
              icon: Icons.keyboard_arrow_left,
              onTap: () => onDirectionChanged(Direction.left),
            ),
          ),
          Positioned(
            right: 0,
            top: 50,
            child: _DirectionButton(
              icon: Icons.keyboard_arrow_right,
              onTap: () => onDirectionChanged(Direction.right),
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DirectionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey.shade800,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
