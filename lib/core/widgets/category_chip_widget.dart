import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';
import '../constants/colors.dart';

class CategoryChipWidget extends StatelessWidget {
  final int pickedValue;
  final int index;
  final List<String> categoryList;

  const CategoryChipWidget({
    super.key,
    required this.pickedValue,
    required this.categoryList,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: index == pickedValue
            ? isDarkMode
                ? AppColors.primary
                : AppColors.secondary
            : Colors.transparent,
        border: Border.all(
          color: index == pickedValue ? Colors.transparent : AppColors.grey,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Text(
        categoryList[index],
        style: TextStyle(
          color: index == pickedValue
              ? isDarkMode
                  ? AppColors.textPrimary
                  : AppColors.textFifth
              : isDarkMode
                  ? AppColors.textFifth
                  : AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
