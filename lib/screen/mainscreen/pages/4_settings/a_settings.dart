import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/services/floating_bubble_service.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/widgets/divider_widget.dart';
import 'package:smart_learn/global.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showLanguage = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.style.theme;
    final languageService = Provider.of<AppLanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(globalLanguage.settings)),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          /// Giao diện --------------------------------------------------------
          Text(globalLanguage.display, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _GroupCard(
            children: [
              /// DARTMODE  ----------------------------------------------------
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: Text(globalLanguage.darkMode),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  setState(() {
                    themeProvider.toggleTheme();
                  });
                },
              ),

              /// MÀU SẮC  -----------------------------------------------------
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: Text(globalLanguage.color),
                trailing: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: themeProvider.themeData.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                onTap: () async {
                  Color selectedColor = themeProvider.themeData.primaryColor;
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: selectedColor,
                            onColorChanged: (color) {
                              selectedColor = color;
                            },
                            pickerAreaHeightPercent: 0.8,
                            enableAlpha: false,
                            displayThumbColor: true,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(globalLanguage.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              themeProvider.updateTheme(selectedColor);
                              Navigator.pop(context);
                            },
                            child: Text(globalLanguage.edit),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 10),
          const WdgDivider(),
          const SizedBox(height: 10),

          /// Nhóm tiện ích ----------------------------------------------------
          Text(globalLanguage.utilities, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _GroupCard(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.bubble_chart),
                title: Text(globalLanguage.floatingUtil),
                value: AppFloatingBubbleService.isBubbleVisible,
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      showFloatingBubble(context);
                    } else {
                      AppFloatingBubbleService.hideBubble();
                    }
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 10),
          const WdgDivider(),
          const SizedBox(height: 10),

          /// Ngôn ngữ  --------------------------------------------------------
          Text(globalLanguage.language, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _GroupCard(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(globalLanguage.language),
                trailing: Icon(_showLanguage ? Icons.expand_less : Icons.expand_more),
                onTap: () {
                  setState(() => _showLanguage = !_showLanguage);
                },
              ),
              if (_showLanguage)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Tiếng Việt"),
                        onTap: () => languageService.changeLanguage(AppLanguageProvider.supportedLocales[0]),
                      ),
                      ListTile(
                        title: const Text("English"),
                        onTap: () => languageService.changeLanguage(AppLanguageProvider.supportedLocales[1]),
                      ),
                      ListTile(
                        title: const Text("简体中文"),
                        onTap: () => languageService.changeLanguage(AppLanguageProvider.supportedLocales[2]),
                      ),
                    ],
                  ),
                ),
            ],
          ),

        ],
      ),
    );
  }
}

/// Nhóm card item  ------------------------------------------------------------
class _GroupCard extends StatelessWidget {
  final List<Widget> children;
  const _GroupCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: children.map((child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: child,
      )).toList(),
    );
  }
}
