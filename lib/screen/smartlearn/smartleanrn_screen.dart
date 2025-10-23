import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_learn/app/config/app_config.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/services/banner_service.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/core/link/routers/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:smart_learn/screen/smartlearn/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SmartLearnScreen extends StatelessWidget {
  const SmartLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppBannerService()),
      ],
      child: const _SmartLearn(),
    );
  }
}

class _SmartLearn extends StatefulWidget {
  const _SmartLearn();

  @override
  State<_SmartLearn> createState() => _SmartLearnState();
}

class _SmartLearnState extends State<_SmartLearn> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();

    _handleInitialLink();
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _navigateTo(uri);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }
  }

  void _handleIncomingLinks() {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _navigateTo(uri);
    }, onError: (err) {
      debugPrint('Error on incoming links: $err');
    });
  }

  void _navigateTo(Uri uri) {
    if (uri.host == 'edit') {
      appRouter.flashCard.goFlashCardSet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerService  = context.watch<AppBannerService>();
    final languageService = context.watch<AppLanguageProvider>();

    return AppTheme(builder: (context, theme) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        title: AppConfig.appName,
        debugShowCheckedModeBanner: AppConfig.isDebug,
        locale: languageService.locale,
        theme: theme,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Material(
                child: SafeArea(
                  child: Column(
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        child: bannerService.currentBanner != null
                            ? bannerService.currentBanner!
                            : const SizedBox.shrink(),
                      ),
                      Expanded(child: child!),
                    ],
                  ),
                ),
              )
          );
        },
        home: const SplashScreen(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
      );
    });
  }
}