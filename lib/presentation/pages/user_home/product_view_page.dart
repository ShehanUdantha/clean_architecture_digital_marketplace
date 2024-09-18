import '../../../core/constants/routes_name.dart';
import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/enum.dart';
import '../../../core/widgets/circular_loading_indicator.dart';
import '../../blocs/product_details/product_details_bloc.dart';
import '../../widgets/user_home/product_details_widget.dart';

class ProductViewPage extends StatefulWidget {
  final String routeName;
  final String productId;
  final String? type;

  const ProductViewPage({
    super.key,
    required this.routeName,
    required this.productId,
    this.type,
  });

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  @override
  void initState() {
    context.read<ProductDetailsBloc>()
      ..add(
        GetProductDetailsEvent(id: widget.productId),
      )
      ..add(GetCartedItemsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          switch (state.status) {
            case BlocStatus.loading:
              return const CircularLoadingIndicator();
            case BlocStatus.success:
              return ProductDetailsWidget(
                product: state.productEntity,
                backFunction: () => _handleBackButton(
                  context,
                  widget.routeName,
                  widget.type,
                ),
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
    );
  }

  _handleBackButton(BuildContext context, String routeName, String? type) {
    if (routeName == BackPageTypes.home.page) {
      context.goNamed(AppRoutes.homePageName);
    } else if (routeName == BackPageTypes.view.page) {
      context.goNamed(
        AppRoutes.viewAllProductsPageName,
        queryParameters: {'type': type},
      );
    }
  }
}
