import '../../../../core/utils/extension.dart';

import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/elevated_button_widget.dart';
import '../../../../core/widgets/elevated_loading_button_widget.dart';
import '../../../../core/widgets/input_field_widget.dart';
import '../../../../core/widgets/page_header_widget.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/routes_name.dart';
import '../../../../core/constants/strings.dart';
import '../../../blocs/admin_tools/add_category/add_category_bloc.dart';
import '../../../blocs/admin_tools/category/category_bloc.dart';
import '../../../widgets/admin/tools/category_list_builder_widget.dart';

class CategoryManagePage extends StatefulWidget {
  const CategoryManagePage({super.key});

  @override
  State<CategoryManagePage> createState() => _CategoryManagePageState();
}

class _CategoryManagePageState extends State<CategoryManagePage> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: Column(
          children: [
            PageHeaderWidget(
              title: 'Manage Categories',
              function: () => _handleBackButton(),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SizedBox(
                  width: Helper.screeWidth(context) * 0.7,
                  child: InputFieldWidget(
                    controller: _categoryController,
                    hint: 'Category Name',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: BlocConsumer<AddCategoryBloc, AddCategoryState>(
                    listener: (context, state) {
                      if (state.status == BlocStatus.error) {
                        context
                            .read<AddCategoryBloc>()
                            .add(SetCategoryStatusToDefault());
                        Helper.showSnackBar(
                          context,
                          state.message == ResponseTypes.failure.response
                              ? AppStrings.categoryAlreadyAdded
                              : state.message,
                        );
                      }
                      if (state.status == BlocStatus.success) {
                        context
                            .read<AddCategoryBloc>()
                            .add(SetCategoryStatusToDefault());
                        context
                            .read<CategoryBloc>()
                            .add(GetAllCategoriesEvent());
                        _categoryController.clear();
                        Helper.showSnackBar(
                          context,
                          AppStrings.categoryAdded,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.status == BlocStatus.loading) {
                        return const ElevatedLoadingButtonWidget(
                          radius: 15.0,
                        );
                      }
                      return ElevatedButtonWidget(
                        title: const Text('Add'),
                        radius: 15.0,
                        function: () => _handleCategoryAdd(),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state.status == BlocStatus.error) {
                  Helper.showSnackBar(
                    context,
                    state.message,
                  );
                }

                if (state.isDeleted && state.status == BlocStatus.success) {
                  context.read<CategoryBloc>().add(SetDeleteStateToDefault());
                  Helper.showSnackBar(
                    context,
                    AppStrings.categoryDeleted,
                  );
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case BlocStatus.loading:
                    return const Center(
                      child: LinearProgressIndicator(
                        color: AppColors.secondary,
                      ),
                    );
                  case BlocStatus.success:
                    return const CategoryListBuilderWidget();
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

  _handleBackButton() {
    context.goNamed(AppRoutes.toolsPageName);
  }

  _handleCategoryAdd() {
    if (_categoryController.text.isNotEmpty) {
      context.read<AddCategoryBloc>().add(
            CategoryButtonClickedEvent(category: _categoryController.text),
          );
    } else {
      Helper.showSnackBar(context, AppStrings.requiredCategory);
    }
  }
}
