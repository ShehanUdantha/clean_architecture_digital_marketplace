import '../../../../core/utils/extension.dart';

import '../../../../core/constants/lists.dart';
import 'line_chart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/base_icon_button_widget.dart';
import '../../../../core/widgets/linear_loading_indicator.dart';
import '../../../blocs/admin_home/admin_home_bloc.dart';
import '../../../blocs/theme/theme_bloc.dart';

class MonthlyStatusWidget extends StatelessWidget {
  const MonthlyStatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return BlocBuilder<AdminHomeBloc, AdminHomeState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    '${state.year} ${AppLists.months(context)[state.month]}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? AppColors.textFifth
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BaseIconButtonWidget(
                        function: () =>
                            _handleBackWordMonthSelect(context, state),
                        size: 30,
                        icon: const Icon(
                          Iconsax.arrow_left_2,
                          color: AppColors.textFourth,
                          size: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Transform.flip(
                        flipX: true,
                        child: BaseIconButtonWidget(
                          function: () =>
                              _handleForWordMonthSelect(context, state),
                          size: 30,
                          icon: const Icon(
                            Iconsax.arrow_left_2,
                            color: AppColors.textFourth,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                context.loc.totalBalance,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textSecondary
                      : AppColors.textThird,
                  fontSize: 13,
                  height: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '${state.totalBalancePercentage > 0 ? "+" : ""}${state.totalBalancePercentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: state.totalBalancePercentage <= 0
                      ? AppColors.textRed
                      : AppColors.textGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: Helper.screeWidth(context) * 0.6,
                child: Text(
                  '\$ ${state.totalBalance.toStringAsFixed(3)}',
                  style: TextStyle(
                    color:
                        isDarkMode ? AppColors.textWhite : AppColors.textFourth,
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const LineChartCard(),
            const SizedBox(
              height: 10,
            ),
            if (state.isMonthlyStatusLoading)
              const LinearLoadingIndicator(
                minHeight: 0.5,
              ),
          ],
        );
      },
    );
  }

  _handleBackWordMonthSelect(
    BuildContext context,
    AdminHomeState adminHomeState,
  ) {
    if (adminHomeState.month != 1) {
      context
          .read<AdminHomeBloc>()
          .add(UpdateMonth(month: adminHomeState.month - 1));
    } else {
      context.read<AdminHomeBloc>().add(const UpdateMonth(month: 12));
      context
          .read<AdminHomeBloc>()
          .add(UpdateYear(year: adminHomeState.year - 1));
    }

    context.read<AdminHomeBloc>().add(GetMonthlyPurchaseStatus());
    context.read<AdminHomeBloc>().add(GetMonthlyTotalBalance());
    context.read<AdminHomeBloc>().add(GetMonthlyTotalBalancePercentage());
    context.read<AdminHomeBloc>().add(GetMonthlyTopSellingProducts());
  }

  _handleForWordMonthSelect(
    BuildContext context,
    AdminHomeState adminHomeState,
  ) {
    if (adminHomeState.month != 12) {
      context
          .read<AdminHomeBloc>()
          .add(UpdateMonth(month: adminHomeState.month + 1));
    } else {
      context.read<AdminHomeBloc>().add(const UpdateMonth(month: 1));
      context
          .read<AdminHomeBloc>()
          .add(UpdateYear(year: adminHomeState.year + 1));
    }

    context.read<AdminHomeBloc>().add(GetMonthlyPurchaseStatus());
    context.read<AdminHomeBloc>().add(GetMonthlyTotalBalance());
    context.read<AdminHomeBloc>().add(GetMonthlyTotalBalancePercentage());
    context.read<AdminHomeBloc>().add(GetMonthlyTopSellingProducts());
  }
}
