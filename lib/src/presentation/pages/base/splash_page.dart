import 'package:flutter/material.dart';

import '../../../core/constants/assets_paths.dart';
import '../../../core/utils/helper.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

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
