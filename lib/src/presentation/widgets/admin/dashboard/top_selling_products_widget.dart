import '../../../../core/widgets/builder_error_message_widget.dart';
import '../../../blocs/theme/theme_cubit.dart';

import '../../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/circular_loading_indicator.dart';
import '../../../blocs/admin_home/admin_home_bloc.dart';
import 'top_selling_product_builder_widget.dart';

class TopSellingProductsWidget extends StatelessWidget {
  const TopSellingProductsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, themeState) {
        final isDarkMode =
            Helper.checkIsDarkMode(context, themeState.themeMode);

        return Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: Helper.screeWidth(context) * 0.6,
                child: Text(
                  context.loc.topSellingProducts,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.textFifth
                        : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: Helper.screeHeight(context) * 0.26,
              child: BlocBuilder<AdminHomeBloc, AdminHomeState>(
                buildWhen: (previous, current) =>
                    previous.monthlyTopSellingProductsListStatus !=
                    current.monthlyTopSellingProductsListStatus,
                builder: (context, state) {
                  switch (state.monthlyTopSellingProductsListStatus) {
                    case BlocStatus.loading:
                      return const CircularLoadingIndicator();
                    case BlocStatus.success:
                      return const TopSellingProductBuilderWidget();
                    case BlocStatus.error:
                      return BuilderErrorMessageWidget(
                        message: state.monthlyTopSellingProductsListMessage,
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
