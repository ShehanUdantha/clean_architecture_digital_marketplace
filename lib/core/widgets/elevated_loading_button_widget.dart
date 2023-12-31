import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'elevated_button_widget.dart';

class ElevatedLoadingButtonWidget extends StatelessWidget {
  final double radius;

  const ElevatedLoadingButtonWidget({
    super.key,
    this.radius = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonWidget(
      title: const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: AppColors.white,
          strokeWidth: 2,
        ),
      ),
      radius: radius,
    );
  }
}
