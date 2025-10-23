import 'package:flutter/material.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/core/link/routers/app_router.dart';
import 'package:smart_learn/app/services/floating_bubble_service.dart';
import '../../../../../global.dart';

class HomeUtilities extends StatelessWidget {
  const HomeUtilities({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.style.color;

    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: color.primaryColor.withAlpha(50),
                blurRadius: 2,
                offset: const Offset(0, 1)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                globalLanguage.utilities,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                children: [
                  _MenuItem(
                      icon: Icons.style,
                      label: globalLanguage.flashCard,
                      onTap: () {
                        appRouter.flashCard.goFlashCardSet(context);
                      }),
                  _MenuItem(
                      icon: Icons.calculate,
                      label: globalLanguage.calculator,
                      onTap: () =>
                          appRouter.calculator.goCalculatorScreen(context)),
                  _MenuItem(
                      icon: Icons.assistant,
                      label: globalLanguage.assistant,
                      onTap: () =>
                          appRouter.assistant.goAssistantScreen(context)),
                  _MenuItem(
                      icon: Icons.translate,
                      label: globalLanguage.translate,
                      onTap: () => appRouter.translate.goTranslation(context)),
                ]),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  globalLanguage.floatingUtil,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ValueListenableBuilder(
                    valueListenable: AppFloatingBubbleService.isVisibled,
                    builder: (context, value, child) {
                      return Switch.adaptive(
                          activeThumbColor: color.primaryColor,
                          value: AppFloatingBubbleService.isBubbleVisible,
                          onChanged: (changed) {
                            if (changed) {
                              showFloatingBubble(context);
                            } else {
                              AppFloatingBubbleService.hideBubble();
                            }
                          });
                    })
              ],
            ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 32,
            color: context.style.color.iconColor,
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
    );
  }
}
