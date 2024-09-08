import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings.dart';
import '../../../blocs/admin_tools/category/category_bloc.dart';
import 'category_and_user_card_widget.dart';

class CategoryListBuilderWidget extends StatelessWidget {
  const CategoryListBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryState = context.watch<CategoryBloc>().state;

    return Expanded(
      child: categoryState.listOfCategories.isNotEmpty
          ? ListView.builder(
              itemCount: categoryState.listOfCategories.length,
              itemBuilder: (context, index) {
                return CategoryAndUserCardWidget(
                  title: categoryState.listOfCategories[index].name,
                  function: () => _handleDeleteButton(
                    context,
                    categoryState.listOfCategories[index].id,
                  ),
                );
              },
            )
          : const Center(
              child: Text(AppStrings.categoriesNotAddedYet),
            ),
    );
  }

  _handleDeleteButton(BuildContext context, String id) {
    context.read<CategoryBloc>().add(
          DeleteCategoriesEvent(id: id),
        );
    context.read<CategoryBloc>().add(GetAllCategoriesEvent());
  }
}
