import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class DropDownWidget extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem> items;
  final Function function;

  const DropDownWidget({
    super.key,
    required this.value,
    required this.items,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
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
      value: value,
      items: items,
      onChanged: (value) => function(value),
    );
  }
}
