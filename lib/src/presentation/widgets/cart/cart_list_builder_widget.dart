import '../../blocs/stripe/stripe_bloc.dart';

import '../../../core/utils/enum.dart';
import '../../../core/widgets/circular_loading_indicator.dart';
import '../../blocs/cart/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/product_linear_card_widget.dart';

class CartListBuilderWidget extends StatelessWidget {
  const CartListBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) =>
          previous.listStatus != current.listStatus,
      builder: (context, state) {
        if (state.listStatus == BlocStatus.loading) {
          return const CircularLoadingIndicator();
        }

        return SizedBox(
          child: OrientationBuilder(
            builder: (context, orientation) {
              return BlocBuilder<StripeBloc, StripeState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, stripeState) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.listOfCartedItems.length,
                    itemBuilder: (context, index) {
                      return ProductLinearCardWidget(
                        product: state.listOfCartedItems[index],
                        isEdit: false,
                        deleteFunction: () =>
                            stripeState.status == BlocStatus.loading
                                ? () {}
                                : _handleDeleteProduct(
                                    context,
                                    state.listOfCartedItems[index].id!,
                                    state.listOfCartedItems.length,
                                  ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _handleDeleteProduct(BuildContext context, String id, int count) {
    context.read<CartBloc>().add(DeleteCartedProductEvent(id: id));
  }
}
