import 'package:flutter/material.dart';

import '../constants/colors.dart';

class NetworkImagePlaceholder extends StatelessWidget {
  const NetworkImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: AppColors.grey,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
