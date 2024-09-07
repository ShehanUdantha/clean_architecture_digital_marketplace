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

  _bodyWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppBarTitleWidget(title: 'Tools'),
              ToolsCardWidget(
                title: 'Manage Products',
                image: 'assets/images/manage_products.png',
                function: () => _handleProductPage(context),
              ),
              const SizedBox(
                height: 16,
              ),
              ToolsCardWidget(
                title: 'Manage Categories',
                image: 'assets/images/manage_categories.png',
                function: () => _handleCategoryPage(context),
              ),
              const SizedBox(
                height: 16,
              ),
              ToolsCardWidget(
                title: 'Manage Users',
                image: 'assets/images/manage_user.png',
                function: () => _handleUserPage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleProductPage(BuildContext context) {
    context.goNamed(AppRoutes.productsManagePageName);
  }

  _handleCategoryPage(BuildContext context) {
    context.goNamed(AppRoutes.categoriesManagePageName);
  }

  _handleUserPage(BuildContext context) {
    context.goNamed(AppRoutes.usersManagePageName);
  }
}
