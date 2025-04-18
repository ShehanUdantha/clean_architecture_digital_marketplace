import '../../../../core/constants/assets_paths.dart';
import '../../../../core/utils/extension.dart';

import '../../../../core/widgets/app_bar_title_widget.dart';
import '../../../../core/constants/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/admin/tools/tools_card_widget.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBarTitleWidget(title: context.loc.tools),
              ToolsCardWidget(
                title: context.loc.manageProducts,
                image: AppAssetsPaths.manageProductsImage,
                function: () => _handleProductPage(context),
              ),
              const SizedBox(
                height: 16,
              ),
              ToolsCardWidget(
                title: context.loc.manageCategories,
                image: AppAssetsPaths.manageCategoriesImage,
                function: () => _handleCategoryPage(context),
              ),
              const SizedBox(
                height: 16,
              ),
              ToolsCardWidget(
                title: context.loc.manageUsers,
                image: AppAssetsPaths.manageUsersImage,
                function: () => _handleUserPage(context),
              ),
              const SizedBox(
                height: 16,
              ),
              ToolsCardWidget(
                title: context.loc.manageNotifications,
                image: AppAssetsPaths.manageNotificationsImage,
                function: () => _handleNotificationPage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleProductPage(BuildContext context) {
    context.goNamed(AppRoutes.productsManagePageName);
  }

  void _handleCategoryPage(BuildContext context) {
    context.goNamed(AppRoutes.categoriesManagePageName);
  }

  void _handleUserPage(BuildContext context) {
    context.goNamed(AppRoutes.usersManagePageName);
  }

  void _handleNotificationPage(BuildContext context) {
    context.goNamed(AppRoutes.notificationManagePageName);
  }
}
