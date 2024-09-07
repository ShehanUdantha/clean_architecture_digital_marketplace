import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helper.dart';

class SubImagesAddButtonWidget extends StatelessWidget {
  const SubImagesAddButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Helper.screeHeight(context),
      width: Helper.isLandscape(context)
          ? Helper.screeWidth(context) * 0.1
          : Helper.screeWidth(context) * 0.2,
      decoration: const BoxDecoration(
        color: AppColors.lightDark,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: const Center(
        child: Icon(
          Iconsax.add,
          color: AppColors.secondary,
          size: 32,
        ),
      ),
    );
  }
}
