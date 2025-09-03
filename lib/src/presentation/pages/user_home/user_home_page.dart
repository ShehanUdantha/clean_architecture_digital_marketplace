import 'dart:io';

import '../../widgets/user_home/product_category_horizontal_list_widget.dart';

import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';

import '../../../core/widgets/main_header_widget.dart';
import '../../widgets/user_home/search_product_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/helper.dart';
import '../../blocs/user_home/user_home_bloc.dart';
import '../../widgets/user_home/base_collection_widget.dart';
import '../../widgets/user_home/product_list_by_category_builder_widget.dart';
import '../../widgets/user_home/search_bar_widget.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _initUserHomePage();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return SafeArea(
      child: BlocBuilder<UserHomeBloc, UserHomeState>(
        buildWhen: (previous, current) =>
            previous.currentCategory != current.currentCategory ||
            previous.userEntity != current.userEntity ||
            previous.searchQuery != current.searchQuery,
        builder: (context, userHomeState) {
          final isSearching = userHomeState.searchQuery.trim().isNotEmpty;

          return Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: Helper.isLandscape(context)
                        ? !isSearching
                            ? Helper.screeHeight(context) *
                                (Platform.isAndroid ? 0.6 : 0.55)
                            : Helper.screeHeight(context) *
                                (Platform.isAndroid ? 0.45 : 0.40)
                        : !isSearching
                            ? Helper.screeHeight(context) *
                                (Platform.isAndroid ? 0.3 : 0.25)
                            : Helper.screeHeight(context) *
                                (Platform.isAndroid ? 0.236 : 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainHeaderWidget(
                          userName: userHomeState.userEntity.userName,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        SearchBarWidget(
                          controller: _searchController,
                          function: (value) => _handleSearchQuery(value),
                          clearFunction: () => _handleClearFunction(),
                        ),
                        const SizedBox(
                          height: 26.0,
                        ),
                        isSearching
                            ? const SizedBox()
                            : const ProductCategoryHorizontalListWidget(),
                      ],
                    ),
                  ),
                  isSearching
                      ? SizedBox(
                          height: Helper.screeHeight(context),
                          child: ListView(
                            physics: const ClampingScrollPhysics(),
                            children: const [
                              SearchProductListBuilderWidget(),
                              SizedBox(
                                height: 26.0,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: Helper.isLandscape(context)
                              ? Helper.screeHeight(context) * 0.15
                              : Helper.screeHeight(context) * 0.58,
                          child: ListView(
                            physics: const ClampingScrollPhysics(),
                            children: [
                              userHomeState.currentCategory == 0
                                  ? const BaseCollectionWidget()
                                  : const ProductsListByCategoryBuilderWidget(),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _initUserHomePage() {
    context.read<UserHomeBloc>()
      ..add(GetUserDetailsEvent())
      ..add(GetCategoriesEvent())
      ..add(GetFeaturedListEvent())
      ..add(GetTrendingListEvent())
      ..add(GetLatestListEvent());

    final getCurrentUserId = context.read<AuthBloc>().currentUserId ?? "-1";
    context
        .read<NotificationBloc>()
        .add(GetNotificationCountEvent(userId: getCurrentUserId));

    Helper.getNotificationPermission();
  }

  void _handleSearchQuery(
    String value,
  ) {
    context.read<UserHomeBloc>().add(SearchFieldChangeEvent(query: value));
    context.read<UserHomeBloc>().add(GetProductsListByQueryEvent());
  }

  void _handleClearFunction() {
    context.read<UserHomeBloc>().add(ClearSearchFiledEvent());
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }
}
