// ignore_for_file: use_build_context_synchronously

import 'package:Pixelcart/src/core/utils/extension.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/widgets/elevated_loading_button_widget.dart';
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
import '../../blocs/theme/theme_bloc.dart';

class CheckOutWidget extends StatelessWidget {
  const CheckOutWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            context.loc.paymentInformation,
            style: TextStyle(
              color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
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
                '\u{20B9}${cartState.subTotal.toStringAsFixed(2)}',
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
            height: 5,
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
                '\u{20B9}${cartState.transactionFee.toStringAsFixed(2)}',
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
            height: 40,
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
                '\u{20B9}${cartState.totalPrice.toStringAsFixed(2)}',
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
            height: 20,
          ),
          BlocConsumer<StripeBloc, StripeState>(
            listener: (context, state) async {
              if (state.status == BlocStatus.error) {
                context.read<StripeBloc>().add(SetStripeStatusToDefault());
                Helper.showSnackBar(
                  context,
                  state.message,
                );
              }

              if (state.paymentStatus == BlocStatus.error) {
                context
                    .read<StripeBloc>()
                    .add(SetStripePaymentStatusToDefault());
                Helper.showSnackBar(
                  context,
                  state.paymentMessage,
                );
              }

              if (state.paymentSheetStatus == BlocStatus.error) {
                context
                    .read<StripeBloc>()
                    .add(SetStripePaymentSheetStatusToDefault());
                Helper.showSnackBar(
                  context,
                  state.paymentSheetMessage,
                );
              }

              if (state.status == BlocStatus.success) {
                context.read<StripeBloc>().add(InitializePaymentSheetEvent());
                context.read<StripeBloc>().add(SetStripeStatusToDefault());
              }

              if (state.paymentStatus == BlocStatus.success) {
                context.read<StripeBloc>().add(PresentPaymentSheetEvent());
                context
                    .read<StripeBloc>()
                    .add(SetStripePaymentStatusToDefault());
              }

              if (state.paymentSheetStatus == BlocStatus.success) {
                context.read<StripeBloc>().add(SetStripeStatusToDefault());

                Helper.showSnackBar(
                  context,
                  context.loc.paymentSuccessful,
                );

                context.read<CartBloc>().add(
                    SetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent());
              }
            },
            builder: (context, state) {
              if (state.status == BlocStatus.loading) {
                return const ElevatedLoadingButtonWidget();
              }
              return ElevatedButtonWidget(
                title: context.loc.checkOut,
                function: () =>
                    _handleCheckOutButtonClick(context, cartState.totalPrice),
              );
            },
          ),
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state.addToPurchaseStatus == BlocStatus.error) {
                context.read<CartBloc>().add(SetAddToPurchaseStatusToDefault());
                Helper.showSnackBar(
                  context,
                  state.addToPurchaseMessage,
                );
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
            child: const SizedBox(),
          ),
          Helper.isLandscape(context)
              ? const SizedBox(
                  height: 12,
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  _handleCheckOutButtonClick(BuildContext context, double totalPrice) {
    context.read<StripeBloc>().add(
          MakePaymentRequestEvent(amount: totalPrice),
        );
  }
}
