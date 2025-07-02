import '../../../core/utils/extension.dart';
import '../../../core/widgets/linear_loading_indicator.dart';
import 'product_grid_view_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum.dart';
import '../../blocs/user_home/user_home_bloc.dart';

class ProductsListByCategoryBuilderWidget extends StatelessWidget {
  const ProductsListByCategoryBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<UserHomeBloc, UserHomeState>(
        buildWhen: (previous, current) =>
            previous.productsStatus != current.productsStatus,
        builder: (context, state) {
          switch (state.productsStatus) {
            case BlocStatus.loading:
              return const LinearLoadingIndicator();
            case BlocStatus.success:
              return ProductGridViewListBuilderWidget(
                productsList: state.listOfProductsByCategory,
                routeName: BackPageTypes.home.page,
              );
            case BlocStatus.error:
              return Center(
                child: Text(state.featuredMessage),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
