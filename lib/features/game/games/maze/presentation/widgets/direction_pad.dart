import 'package:flutter/material.dart';
import 'package:smart_learn/features/game/shared/widgets/button_widget.dart';

enum Direction { up, down, left, right }

class DirectionPad extends StatelessWidget {
  final void Function(Direction direction) onDirectionChanged;

  const DirectionPad({super.key, required this.onDirectionChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 65,
            child: _DirectionButton(
              icon: Icons.keyboard_arrow_up,
              onTap: () => onDirectionChanged(Direction.up),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 65,
            child: _DirectionButton(
              icon: Icons.keyboard_arrow_down,
              onTap: () => onDirectionChanged(Direction.down),
            ),
          ),
          Positioned(
            left: 0,
            top: 65,
            child: _DirectionButton(
              icon: Icons.keyboard_arrow_left,
              onTap: () => onDirectionChanged(Direction.left),
            ),
          ),
          Positioned(
            right: 0,
            top: 65,
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
    return Padding(
      padding: const EdgeInsets.all(1),
      child: WIDButtonGame(
        onPressed: onTap,
        radius: BorderRadius.circular(8),
        child: Icon(icon, size: 50),
      ),
    );
  }
}
