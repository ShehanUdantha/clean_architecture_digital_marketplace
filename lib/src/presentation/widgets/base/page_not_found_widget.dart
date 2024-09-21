import '../../../core/constants/assets_paths.dart';
import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/theme/theme_bloc.dart';

class PageNotFoundWidget extends StatelessWidget {
  const PageNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);
    return SafeArea(
      child: Padding(
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
                  color:
                      isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
