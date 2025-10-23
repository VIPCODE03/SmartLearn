import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_learn/app/assets/app_assets.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/screen/mainscreen/mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AppRouterMixin {

  @override
  void initState() {
    super.initState();
    _appInit();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Image.asset(AppAssets.path.images.splashGif),
      ),
    );
  }

  Future<void> _appInit() async {
    await TeXRenderingServer.start();
    await initializeDateFormatting('vi_VN', null);
    await initAppDI();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await Future.delayed(const Duration(seconds: 1));
    if(!mounted) return;
    pushSlideLeftReplace(context, const MainScreen());
  }
}
