import 'package:flutter/cupertino.dart';
import 'package:smart_learn/app/assets/app_assets.dart';

class WdgLoading extends StatelessWidget {
  final double? height;
  final double? width;
  
  const WdgLoading({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 100,
      width: width ?? 100,
      child: Image.asset(
        AppAssets.path.images.loadingGif,
        fit: BoxFit.cover,
      ),
    );
  }
}

