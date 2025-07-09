import '../../blocs/theme/theme_cubit.dart';

import '../../../core/constants/assets_paths.dart';
import '../../../core/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/elevated_button_widget.dart';

class NoItemsInCartWidget extends StatelessWidget {
  const NoItemsInCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, themeState) {
        final isDarkMode =
            Helper.checkIsDarkMode(context, themeState.themeMode);

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
              image: const AssetImage(AppAssetsPaths.emptyCartImage),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              context.loc.emptyCart,
              style: TextStyle(
                color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              context.loc.emptyCartMessage,
              style: const TextStyle(
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
              title: context.loc.exploreProducts,
              function: () => _handleExploreButton(context),
            ),
            const SizedBox(
              height: 16.0,
            ),
          ],
        );
      },
    );
  }

  void _handleExploreButton(BuildContext context) {
    context.goNamed(AppRoutes.homePageName);
  }
}
