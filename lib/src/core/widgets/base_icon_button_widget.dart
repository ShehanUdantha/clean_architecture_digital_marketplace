import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';

class BaseIconButtonWidget extends StatelessWidget {
  final Function function;
  final Icon icon;
  final Color bgColor;
  final Color borderColor;
  final bool isNotify;
  final double size;

  const BaseIconButtonWidget({
    super.key,
    required this.function,
    this.icon = const Icon(
      Iconsax.arrow_left_2,
      color: AppColors.textFourth,
    ),
    this.bgColor = AppColors.white,
    this.borderColor = AppColors.lightGrey,
    this.isNotify = false,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(50.0),
            ),
          ),
          child: Center(
            child: IconButton(
              onPressed: () => function(),
              icon: icon,
            ),
          ),
        ),
        isNotify
            ? Positioned(
                right: 10,
                top: 8,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.lightRed,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
