import 'dart:io';

import '../../../core/utils/helper.dart';
import '../../../core/widgets/category_chip_widget.dart';
import '../../blocs/user_home/user_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCategoryHorizontalListWidget extends StatelessWidget {
  const ProductCategoryHorizontalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserHomeBloc, UserHomeState>(
      buildWhen: (previous, current) =>
          previous.listOfCategories != current.listOfCategories ||
          previous.currentCategory != current.currentCategory,
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: Helper.isLandscape(context)
                  ? Helper.screeHeight(context) *
                      (Platform.isAndroid ? 0.10 : 0.09)
                  : Helper.screeHeight(context) *
                      (Platform.isAndroid ? 0.05 : 0.042),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                itemCount: state.listOfCategories.length + 1,
                itemBuilder: (context, index) {
                  final categoryList = Helper.createCategoryHorizontalList(
                    state.listOfCategories,
                  );
                  return GestureDetector(
                    onTap: () => _handleCategoryChipButton(
                      context,
                      index,
                      categoryList,
                    ),
                    child: CategoryChipWidget(
                      index: index,
                      pickedValue: state.currentCategory,
                      categoryList: categoryList,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleCategoryChipButton(
    BuildContext context,
    int index,
    List<String> list,
  ) {
    context.read<UserHomeBloc>().add(
          CategoryClickedEvent(
            value: index,
            name: list[index],
          ),
        );
    context.read<UserHomeBloc>().add(GetProductsListByCategoryEvent());
  }
}
