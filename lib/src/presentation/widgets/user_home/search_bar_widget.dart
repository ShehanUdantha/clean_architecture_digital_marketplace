import 'dart:async';

import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/colors.dart';
import '../../blocs/theme/theme_bloc.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function function;
  final Function clearFunction;

  const SearchBarWidget({
    super.key,
    required this.function,
    required this.clearFunction,
    required this.controller,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return TextField(
      controller: widget.controller,
      onChanged: (value) => _searchOnChangeFunction(value),
      style: TextStyle(
        color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(Iconsax.search_normal),
        prefixIconColor: AppColors.mediumGrey,
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                onPressed: () => widget.clearFunction(),
                icon: const Icon(Iconsax.close_circle),
              )
            : const SizedBox(),
        suffixIconColor:
            isDarkMode ? AppColors.secondWhite : AppColors.secondary,
        hintText: context.loc.searchProducts,
        hintStyle: const TextStyle(
          color: AppColors.mediumGrey,
          fontWeight: FontWeight.normal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppColors.mediumGrey),
        ),
      ),
    );
  }

  void _searchOnChangeFunction(String? value) {
    // cancel timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // start new timer
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        widget.function(value);
      },
    );
  }
}
