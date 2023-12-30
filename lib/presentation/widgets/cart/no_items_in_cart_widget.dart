import 'package:Pixelcart/core/constants/routes_name.dart';
import 'package:Pixelcart/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/widgets/elevated_button_widget.dart';

class NoItemsInCartWidget extends StatelessWidget {
  const NoItemsInCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: Helper.screeHeight(context) * 0.1,
        ),
        Image(
          height: Helper.isLandscape(context)
              ? Helper.screeHeight(context) * 0.6
              : Helper.screeHeight(context) * 0.3,
          image: const AssetImage('assets/images/empty_cart.png'),
        ),
        const SizedBox(
          height: 8.0,
        ),
        const Text(
          AppStrings.emptyCart,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16.0,
        ),
        const Text(
          AppStrings.emptyCartMessage,
          style: TextStyle(
            color: AppColors.mediumGrey,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 32.0,
        ),
        ElevatedButtonWidget(
          title: const Text('Explore Products'),
          function: () => _handleExploreButton(context),
        ),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }

  _handleExploreButton(BuildContext context) {
    context.goNamed(AppRoutes.homePageName);
  }
}
