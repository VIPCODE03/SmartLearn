import 'package:flutter/material.dart';
import 'package:smart_learn/core/router/app_router.dart';
import 'package:smart_learn/services/floating_bubble_service.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';
import '../../../../../global.dart';

class HomeUtilities extends StatelessWidget {
  const HomeUtilities({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: primaryColor(context).withAlpha(50),
                blurRadius: 2,
                offset: const Offset(0, 1)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Tiện ích',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),

            Center(
              child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _MenuItem(
                        icon: Icons.style,
                        label: 'Thêm thẻ',
                        onTap: () {
                          appRouter.flashCard.goFlashCardSet(context);
                        }
                    ),

                    _MenuItem(
                        icon: Icons.calculate,
                        label: 'Máy tính',
                        onTap: () => appRouter.calculator.goCalculatorScreen(context)
                    ),

                    _MenuItem(
                        icon: Icons.assistant,
                        label: 'Trợ lý',
                        onTap: () => appRouter.assistant.goAssistantScreen(context)
                    ),

                    _MenuItem(
                        icon: Icons.translate,
                        label: 'Dịch thuật',
                        onTap: () => appRouter.translate.goTranslation(context)
                    ),

                    _MenuItem(
                        icon: Icons.gamepad,
                        label: 'Game',
                        onTap: () => appRouter.game.goGameScreen(context)
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tiện ích nổi',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ValueListenableBuilder(
                            valueListenable: FloatingBubbleService.isVisibled,
                            builder: (context, value, child) {
                              return Switch.adaptive(
                                activeColor: primaryColor(context),
                                value: FloatingBubbleService.isBubbleVisible,
                                onChanged: (changed) {
                                  if(changed) {
                                    showFloatingBubble(context);
                                  }
                                  else {
                                    hideFloatingBubble();
                                  }
                                });
                            }
                        )
                      ],
                    ),
                  ]
              ),
            )
          ],
        )
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return WdgBounceButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: iconColor(context),
            ),

            const SizedBox(height: 8),

            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
