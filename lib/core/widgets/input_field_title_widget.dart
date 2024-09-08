import '../../core/constants/colors.dart';
import 'package:flutter/material.dart';

class InputFieldTitleWidget extends StatelessWidget {
  final String title;

  const InputFieldTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary.withOpacity(0.8),
        ),
      ),
    );
  }
}
