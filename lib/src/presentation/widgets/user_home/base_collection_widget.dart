import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extension.dart';
import 'collection_header_widget.dart';
import 'featured_list_builder_widget.dart';
import 'latest_list_builder_widget.dart';
import 'trending_list_builder_widget.dart';

class BaseCollectionWidget extends StatelessWidget {
  const BaseCollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CollectionHeaderWidget(
          title: context.loc.featured,
          clickFunction: () => _handleViewAllPage(
            context,
            MarketingTypes.featured.types,
            context.loc.featured,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        const FeaturedListBuilderWidget(),
        const SizedBox(
          height: 16.0,
        ),
        CollectionHeaderWidget(
          title: context.loc.trending,
          clickFunction: () => _handleViewAllPage(
            context,
            MarketingTypes.trending.types,
            context.loc.trending,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        const TrendingListBuilderWidget(),
        const SizedBox(
          height: 16.0,
        ),
        CollectionHeaderWidget(
          title: context.loc.latest,
          clickFunction: () => _handleViewAllPage(
            context,
            MarketingTypes.latest.types,
            context.loc.latest,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        const LatestListBuilderWidget(),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }

  void _handleViewAllPage(BuildContext context, String type, String title) {
    context.goNamed(
      AppRoutes.viewAllProductsPageName,
      queryParameters: {
        'type': type,
        'title': title,
      },
    );
  }
}
