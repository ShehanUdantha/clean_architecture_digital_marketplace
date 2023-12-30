import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils/helper.dart';

class AppBarTitleWidget extends StatelessWidget {
  final String title;

  const AppBarTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Helper.isLandscape(context)
          ? Helper.screeHeight(context) * 0.15
          : Helper.screeHeight(context) * 0.065,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
