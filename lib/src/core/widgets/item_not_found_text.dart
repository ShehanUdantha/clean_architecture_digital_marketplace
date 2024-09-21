// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';

class ItemNotFoundText extends StatelessWidget {
  final String title;

  const ItemNotFoundText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Center(
      child: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
        ),
      ),
    );
  }
}
