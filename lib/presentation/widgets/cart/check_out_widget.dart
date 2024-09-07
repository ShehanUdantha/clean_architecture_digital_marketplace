// ignore_for_file: use_build_context_synchronously

import 'package:Pixelcart/core/constants/routes_name.dart';
import 'package:Pixelcart/core/constants/strings.dart';
import 'package:Pixelcart/core/utils/enum.dart';
import 'package:Pixelcart/core/widgets/elevated_loading_button_widget.dart';
import 'package:Pixelcart/presentation/blocs/cart/cart_bloc.dart';
import 'package:Pixelcart/presentation/blocs/purchase/purchase_bloc.dart';
import 'package:Pixelcart/presentation/blocs/stripe/stripe_bloc.dart';
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
    final cartState = context.watch<CartBloc>().state;

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Payment Information',
            style: TextStyle(
              color: AppColors.textPrimary,
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
              const Text(
                'Sub Total',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              Text(
                '\u{20B9}${cartState.subTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
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
              const Text(
                'Transaction Fee',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              Text(
                '\u{20B9}${cartState.transactionFee.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
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
              const Text(
                'Total',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              Text(
                '\u{20B9}${cartState.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
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
                  AppStrings.paymentSuccessful,
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
                title: const Text(
                  'Check Out',
                  style: TextStyle(color: AppColors.white),
                ),
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
