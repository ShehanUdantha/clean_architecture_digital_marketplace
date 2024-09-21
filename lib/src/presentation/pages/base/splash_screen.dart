import 'package:flutter/material.dart';

import '../../../core/constants/assets_paths.dart';
import '../../../core/utils/helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: const AssetImage(AppAssetsPaths.splashImage),
          height: Helper.screeHeight(context) * 0.25,
          width: Helper.screeWidth(context) * 0.25,
        ),
      ),
    );
  }
}
