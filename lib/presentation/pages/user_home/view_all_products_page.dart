import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/page_header_widget.dart';
import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../blocs/user_home/user_home_bloc.dart';
import '../../widgets/user_home/product_grid_view_list_builder_widget.dart';

class ViewAllProductsPage extends StatelessWidget {
  final String type;

  const ViewAllProductsPage({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _bodyWidget(context, type),
      ),
    );
  }

  _bodyWidget(BuildContext context, String type) {
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            PageHeaderWidget(
              title: '$type Products',
              function: () => _handleBackButton(context),
            ),
            const SizedBox(
              height: 16,
            ),
            ProductGridViewListBuilderWidget(
              productsList: _handleGetClickedType(
                type,
                context,
              ),
              routeName: BackPageTypes.view.page,
              type: type,
            ),
          ],
        ),
      ),
    );
  }

  _handleBackButton(BuildContext context) {
    context.goNamed(AppRoutes.homePageName);
  }

  _handleGetClickedType(
    String type,
    BuildContext context,
  ) {
    final userHomeState = context.watch<UserHomeBloc>().state;

    if (type == MarketingTypes.featured.types) {
      return userHomeState.listOfFeatured;
    } else if (type == MarketingTypes.trending.types) {
      return userHomeState.listOfTrending;
    } else if (type == MarketingTypes.latest.types) {
      return userHomeState.listOfLatest;
    }
  }
}
