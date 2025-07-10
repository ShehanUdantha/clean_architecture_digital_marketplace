// ignore_for_file: use_build_context_synchronously

import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/purchase/purchase_bloc.dart';
import '../../blocs/stripe/stripe_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/helper.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../blocs/product_details/product_details_bloc.dart';

class CheckOutWidget extends StatelessWidget {
  const CheckOutWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, themeState) {
          final isDarkMode =
              Helper.checkIsDarkMode(context, themeState.themeMode);

          return BlocConsumer<CartBloc, CartState>(
            listenWhen: (previous, current) =>
                previous.addToPurchaseStatus != current.addToPurchaseStatus,
            listener: (context, state) {
              if (state.addToPurchaseStatus == BlocStatus.error) {
                Helper.showSnackBar(
                  context,
                  state.addToPurchaseMessage,
                );
                context.read<CartBloc>().add(SetAddToPurchaseStatusToDefault());
              }
              if (state.addToPurchaseStatus == BlocStatus.success) {
                context
                    .read<CartBloc>()
                    .add(GetAllCartedProductsDetailsByIdEvent());

                context.read<ProductDetailsBloc>().add(GetCartedItemsEvent());

                context.read<CartBloc>().add(SetAddToPurchaseStatusToDefault());

                context.read<PurchaseBloc>().add(GetAllPurchaseHistory());

                context.goNamed(AppRoutes.purchaseHistoryPageName);
              }
            },
            buildWhen: (previous, current) =>
                previous.subTotal != current.subTotal ||
                previous.transactionFee != current.transactionFee ||
                previous.totalPrice != current.totalPrice,
            builder: (context, cartState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    context.loc.paymentInformation,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textFifth
                          : AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.loc.subTotal,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${cartState.subTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.loc.transactionFee,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${cartState.transactionFee.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.loc.total,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${cartState.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  BlocConsumer<StripeBloc, StripeState>(
                    listenWhen: (previous, current) =>
                        previous.status != current.status,
                    listener: (context, state) async {
                      if (state.status == BlocStatus.error) {
                        Helper.showSnackBar(
                          context,
                          state.message,
                        );
                      }

                      if (state.status == BlocStatus.success) {
                        context
                            .read<StripeBloc>()
                            .add(SetStripePaymentValuesToDefault());

                        Helper.showSnackBar(
                          context,
                          context.loc.paymentSuccessful,
                        );

                        context.read<CartBloc>().add(
                            SetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent());
                      }
                    },
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      final isLoading = state.status == BlocStatus.loading;

                      return ElevatedButtonWidget(
                        title: context.loc.checkOut,
                        function: () => isLoading
                            ? () {}
                            : _handleCheckOutButtonClick(
                                context,
                                cartState.totalPrice,
                              ),
                        isButtonLoading: isLoading,
                      );
                    },
                  ),
                  SizedBox(
                    height: Helper.isLandscape(context) ? 12.0 : 0.0,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _handleCheckOutButtonClick(BuildContext context, double totalPrice) {
    context.read<StripeBloc>().add(
          MakePaymentRequestEvent(amount: totalPrice),
        );
  }
}
