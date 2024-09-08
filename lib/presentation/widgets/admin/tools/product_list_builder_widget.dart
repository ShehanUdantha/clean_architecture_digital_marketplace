import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/product/product_entity.dart';
import '../../../../core/constants/routes_name.dart';
import '../../../../core/widgets/product_linear_card_widget.dart';
import '../../../../core/constants/strings.dart';
import '../../../blocs/admin_tools/product/product_bloc.dart';

class ProductListBuilderWidget extends StatelessWidget {
  const ProductListBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<ProductBloc>().state;

    return Expanded(
      child: productState.listOfProducts.isNotEmpty
          ? ListView.builder(
              itemCount: productState.listOfProducts.length,
              itemBuilder: (context, index) {
                return ProductLinearCardWidget(
                  product: productState.listOfProducts[index],
                  deleteFunction: () => _handleDeleteProduct(
                    context,
                    productState.listOfProducts[index].id!,
                  ),
                  editFunction: () => _handleEditProduct(
                    context,
                    productState.listOfProducts[index],
                  ),
                );
              },
            )
          : const Center(
              child: Text(AppStrings.productsNotAddedYet),
            ),
    );
  }

  _handleDeleteProduct(
    BuildContext context,
    String id,
  ) {
    context.read<ProductBloc>().add(ProductDeleteEvent(id: id));
    context.read<ProductBloc>().add(GetAllProductsEvent());
  }

  _handleEditProduct(BuildContext context, ProductEntity product) {
    context.goNamed(
      AppRoutes.productsAddPageName,
      queryParameters: {'title': 'Update'},
      extra: product,
    );
  }
}
