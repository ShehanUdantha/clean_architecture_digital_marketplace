import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/routes_name.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/extension.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/category_chip_widget.dart';
import '../../../../core/widgets/linear_loading_indicator.dart';
import '../../../../core/widgets/page_header_widget.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../widgets/admin/tools/floating_button_widget.dart';
import '../../../widgets/admin/tools/product_list_builder_widget.dart';

class ProductManagePage extends StatelessWidget {
  const ProductManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
      floatingActionButton: FloatingButtonWidget(
        function: () => _handleFloatingButton(context),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final categoryState = context.watch<CategoryBloc>().state;
    final productState = context.watch<ProductBloc>().state;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: Column(
          children: [
            PageHeaderWidget(
              title: context.loc.manageProducts,
              function: () => _handleBackButton(context),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: Helper.isLandscape(context)
                  ? Helper.screeHeight(context) * 0.10
                  : Helper.screeHeight(context) * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                itemCount: categoryState.listOfCategories.length + 1,
                itemBuilder: (context, index) {
                  final categoryList = Helper.createCategoryHorizontalList(
                    categoryState.listOfCategories,
                  );
                  return GestureDetector(
                    onTap: () => _handleCategoryChipButton(
                      context,
                      index,
                      categoryList,
                    ),
                    child: CategoryChipWidget(
                      index: index,
                      pickedValue: productState.currentCategory,
                      categoryList: categoryList,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            BlocConsumer<ProductBloc, ProductState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.isDeleted != current.isDeleted,
              listener: (context, state) {
                if (state.status == BlocStatus.error) {
                  Helper.showSnackBar(
                    context,
                    state.message,
                  );
                }
                if (state.isDeleted && state.status == BlocStatus.success) {
                  context
                      .read<ProductBloc>()
                      .add(SetProductDeleteStateToDefault());

                  Helper.showSnackBar(
                    context,
                    context.loc.productDeleted,
                  );

                  context.read<ProductBloc>().add(GetAllProductsEvent());
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case BlocStatus.loading:
                    return const LinearLoadingIndicator();
                  case BlocStatus.success:
                    return const ProductListBuilderWidget();
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
    );
  }

  void _handleBackButton(BuildContext context) {
    context.goNamed(AppRoutes.toolsPageName);
  }

  void _handleFloatingButton(BuildContext context) {
    context.goNamed(
      AppRoutes.productsAddPageName,
      queryParameters: {'title': CURDTypes.add.name},
    );
  }

  void _handleCategoryChipButton(
    BuildContext context,
    int index,
    List<String> list,
  ) {
    context.read<ProductBloc>().add(
          CategorySelectEvent(
            value: index,
            name: list[index],
          ),
        );

    context.read<ProductBloc>().add(
          GetAllProductsEvent(),
        );
  }
}
