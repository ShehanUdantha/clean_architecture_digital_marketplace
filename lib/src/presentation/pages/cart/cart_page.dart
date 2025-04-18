import '../../../core/utils/extension.dart';
import '../../../core/widgets/app_bar_title_widget.dart';
import '../../../core/widgets/circular_loading_indicator.dart';
import '../../widgets/cart/no_items_in_cart_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import 'package:flutter/material.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/product_details/product_details_bloc.dart';
import '../../widgets/cart/cart_list_builder_widget.dart';
import '../../widgets/cart/check_out_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    context.read<CartBloc>().add(GetAllCartedProductsDetailsByIdEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarTitleWidget(title: context.loc.cart),
              BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state.status == BlocStatus.error) {
                    Helper.showSnackBar(
                      context,
                      state.message,
                    );
                  }
                  if (state.status == BlocStatus.success) {
                    if (state.message == CURDTypes.remove.curd) {
                      Helper.showSnackBar(
                        context,
                        context.loc.productRemovedFromCart,
                      );
                      context
                          .read<CartBloc>()
                          .add(SetCartStateToDefaultEvent());
                      context
                          .read<CartBloc>()
                          .add(UpdateCartedProductsDetailsByIdEvent());
                      context
                          .read<ProductDetailsBloc>()
                          .add(GetCartedItemsEvent());
                    }
                  }
                },
                builder: (context, state) {
                  switch (state.status) {
                    case BlocStatus.loading:
                      return SizedBox(
                        height: Helper.screeHeight(context) * 0.8,
                        child: const CircularLoadingIndicator(),
                      );
                    case BlocStatus.success:
                      return Column(
                        children: [
                          state.listOfCartedItems.isNotEmpty
                              ? SizedBox(
                                  height: Helper.screeHeight(context) * 0.472,
                                  child: const CartListBuilderWidget(),
                                )
                              : const NoItemsInCartWidget(),
                          state.listOfCartedItems.isNotEmpty
                              ? const CheckOutWidget()
                              : const SizedBox(),
                        ],
                      );
                    case BlocStatus.error:
                      return Center(
                        child: Text(state.message),
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
