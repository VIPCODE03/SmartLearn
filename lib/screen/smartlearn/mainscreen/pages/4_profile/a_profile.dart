import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/services/floating_bubble_service.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/global.dart';

class PS extends StatelessWidget {
  const PS({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.style.theme;
    final languageService = Provider.of<AppLanguageProvider>(context);

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
            value: AppFloatingBubbleService.isBubbleVisible,
            onChanged: (value) => {
              if(value) {
                showFloatingBubble(context)
              }
              else {
                AppFloatingBubbleService.hideBubble()
              }
            },
          ),
          const SizedBox(height: 20),
          const Text("Chọn màu chính:", style: TextStyle(fontSize: 16)),
          Wrap(
            children: AppColor.primaryColors.map((color) {
              return GestureDetector(
                onTap: () => themeProvider.updateTheme(color),
                child: Container(
                  width: 40, height: 40, margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text("Chọn màu phụ:", style: TextStyle(fontSize: 16)),
          Wrap(children: [
            InkWell(
              onTap: () {
                languageService.changeLanguage(AppLanguageProvider.supportedLocales[0]);
              },
              child: const Text('en', style: TextStyle(fontSize: 20),),
            ),
            const SizedBox(width: 10, height: 10,),
            InkWell(
              onTap: () {
                languageService.changeLanguage(AppLanguageProvider.supportedLocales[1]);
              },
              child: const Text('vi', style: TextStyle(fontSize: 20),),
            )
          ])
        ],
      ),
    );
  }
}
