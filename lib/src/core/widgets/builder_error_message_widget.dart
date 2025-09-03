// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:Pixelcart/src/core/constants/colors.dart';

class BuilderErrorMessageWidget extends StatelessWidget {
  final String message;

  const BuilderErrorMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: AppColors.amberColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
