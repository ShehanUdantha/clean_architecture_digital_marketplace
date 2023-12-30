import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class CollectionHeaderWidget extends StatelessWidget {
  final String title;
  final Function clickFunction;

  const CollectionHeaderWidget({
    super.key,
    required this.title,
    required this.clickFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () => clickFunction(),
          child: const Text(
            'View All',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
