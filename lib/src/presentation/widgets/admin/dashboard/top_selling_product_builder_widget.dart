import '../../../../core/utils/extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/item_not_found_text.dart';
import '../../../../core/widgets/product_linear_card_widget.dart';
import '../../../blocs/admin_home/admin_home_bloc.dart';

class TopSellingProductBuilderWidget extends StatelessWidget {
  const TopSellingProductBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final adminHomeState = context.watch<AdminHomeBloc>().state;

    return adminHomeState.listOfTopSellingProduct.isNotEmpty
        ? ListView.builder(
            itemCount: adminHomeState.listOfTopSellingProduct.length,
            itemBuilder: (context, index) {
              return ProductLinearCardWidget(
                product: adminHomeState.listOfTopSellingProduct[index],
                isEdit: false,
                isAction: false,
              );
            },
          )
        : ItemNotFoundText(title: context.loc.productsNotFound);
  }
}
