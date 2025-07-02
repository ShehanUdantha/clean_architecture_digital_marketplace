import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum.dart';
import '../../../core/widgets/linear_loading_indicator.dart';
import '../../blocs/user_home/user_home_bloc.dart';
import 'product_grid_view_list_builder_widget.dart';

class SearchProductListBuilderWidget extends StatelessWidget {
  const SearchProductListBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<UserHomeBloc, UserHomeState>(
        buildWhen: (previous, current) =>
            previous.searchProductsStatus != current.searchProductsStatus,
        builder: (context, state) {
          switch (state.searchProductsStatus) {
            case BlocStatus.loading:
              return const LinearLoadingIndicator();
            case BlocStatus.success:
              return ProductGridViewListBuilderWidget(
                productsList: state.listOfSearchProducts,
                routeName: BackPageTypes.home.page,
              );
            case BlocStatus.error:
              return Center(
                child: Text(state.searchProductsMessage),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
