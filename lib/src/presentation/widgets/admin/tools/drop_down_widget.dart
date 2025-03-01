import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class DropDownWidget<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> function;
  final bool isReadOnly;

  const DropDownWidget({
    super.key,
    required this.value,
    required this.items,
    required this.function,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
      ),
      style: const TextStyle(
        color: AppColors.textThird,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      dropdownColor: AppColors.white,
      value: value,
      items: items,
      onChanged: isReadOnly ? null : function,
    );
  }
}
