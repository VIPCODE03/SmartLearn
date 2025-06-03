import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_learn/config/language_config.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/services/language_service.dart';
import '../../../../../providers/theme_provider.dart';
import '../../../../../services/floating_bubble_service.dart';

class PS extends StatelessWidget {
  const PS({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Chọn Theme")),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Chế độ tối"),
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
          SwitchListTile(
            title: const Text("Bật tiện ích"),
            value: FloatingBubbleService.isBubbleVisible,
            onChanged: (value) => {
              if(value) {
                showFloatingBubble(context)
              }
              else {
                hideFloatingBubble()
              }
            },
          ),
          const SizedBox(height: 20),
          const Text("Chọn màu chính:", style: TextStyle(fontSize: 16)),
          Wrap(
            children: ThemeProvider.primaryColors.map((color) {
              return GestureDetector(
                onTap: () => themeProvider.updateTheme(color, themeProvider.secondaryColor),
                child: Container(
                  width: 40, height: 40, margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text("Chọn màu phụ:", style: TextStyle(fontSize: 16)),
          Wrap(
            children: ThemeProvider.secondaryColors.map((color) {
              return GestureDetector(
                onTap: () => themeProvider.updateTheme(themeProvider.primaryColor, color),
                child: Container(
                  width: 40, height: 40, margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              );
            }).toList(),
          ),
          Wrap(children: [
            InkWell(
              onTap: () {
                languageService.changeLanguage(LanguageConfig.supportedLocales[0]);
              },
              child: const Text('en', style: TextStyle(fontSize: 20),),
            ),
            SizedBox(width: 10, height: 10,),
            InkWell(
              onTap: () {
                languageService.changeLanguage(LanguageConfig.supportedLocales[1]);
              },
              child: const Text('vi', style: TextStyle(fontSize: 20),),
            )
          ])
        ],
      ),
    );
  }
}
