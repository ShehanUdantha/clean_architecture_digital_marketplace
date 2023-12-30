import 'base_icon_button_widget.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils/helper.dart';

class PageHeaderWidget extends StatelessWidget {
  final Function function;
  final String title;
  const PageHeaderWidget({
    super.key,
    required this.function,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Helper.isLandscape(context)
          ? Helper.screeHeight(context) * 0.15
          : Helper.screeHeight(context) * 0.08,
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 10,
            child: BaseIconButtonWidget(
              function: () => function(),
            ),
          ),
        ],
      ),
    );
  }
}
