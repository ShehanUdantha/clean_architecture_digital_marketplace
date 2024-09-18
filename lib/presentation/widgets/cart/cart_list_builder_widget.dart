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
    final cartState = context.watch<CartBloc>().state;

    if (cartState.listStatus == BlocStatus.loading) {
      return const CircularLoadingIndicator();
    }

    return SizedBox(
      child: OrientationBuilder(
        builder: (context, orientation) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: cartState.listOfCartedItems.length,
            itemBuilder: (context, index) {
              return ProductLinearCardWidget(
                product: cartState.listOfCartedItems[index],
                isEdit: false,
                deleteFunction: () => _handleDeleteProduct(
                  context,
                  cartState.listOfCartedItems[index].id!,
                  cartState.listOfCartedItems.length,
                ),
              );
            },
          );
        },
      ),
    );
  }

  _handleDeleteProduct(BuildContext context, String id, int count) {
    context.read<CartBloc>().add(DeleteCartedProductEvent(id: id));
  }
}
