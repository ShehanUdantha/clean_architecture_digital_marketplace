import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: index == pickedValue ? AppColors.secondary : Colors.transparent,
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
          color: index == pickedValue ? AppColors.white : AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
