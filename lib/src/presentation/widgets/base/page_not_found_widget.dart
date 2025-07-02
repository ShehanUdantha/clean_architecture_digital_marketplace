import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';

import '../../../core/constants/assets_paths.dart';
import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';

class PageNotFoundWidget extends StatelessWidget {
  const PageNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, themeState) {
          final isDarkMode =
              Helper.checkIsDarkMode(context, themeState.themeMode);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: Helper.screeHeight(context) * 0.10,
                  ),
                  Image(
                    height: Helper.isLandscape(context)
                        ? Helper.screeHeight(context) * 0.8
                        : Helper.screeHeight(context) * 0.4,
                    image: const AssetImage(AppAssetsPaths.pageNotFoundImage),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    context.loc.pageNotFound,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textFifth
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
