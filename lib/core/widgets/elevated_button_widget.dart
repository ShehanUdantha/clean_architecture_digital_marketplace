import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final Widget title;
  final Function? function;
  final double radius;

  const ElevatedButtonWidget({
    super.key,
    required this.title,
    this.function,
    this.radius = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => function != null ? function!() : () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.lightGrey,
        backgroundColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        textStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: title,
    );
  }
}
