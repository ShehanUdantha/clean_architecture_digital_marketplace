import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../blocs/theme/theme_bloc.dart';

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
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () => clickFunction(),
          child: Text(
            context.loc.viewAll,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
