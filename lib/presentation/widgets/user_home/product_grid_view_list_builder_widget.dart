// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:Pixelcart/domain/entities/product/product_entity.dart';
import 'package:Pixelcart/presentation/widgets/user_home/grid_product_card_widget.dart';

import '../../../core/constants/strings.dart';
import '../../../core/utils/helper.dart';

class ProductGridViewListBuilderWidget extends StatelessWidget {
  final List<ProductEntity> productsList;
  final String routeName;
  final String? type;

  const ProductGridViewListBuilderWidget({
    Key? key,
    required this.productsList,
    required this.routeName,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: productsList.isNotEmpty
          ? OrientationBuilder(
              builder: (context, orientation) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Helper.isLandscape(context) ? 3 : 2,
                    childAspectRatio: Helper.isLandscape(context) ? 0.85 : 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    return GridProductCard(
                      product: productsList[index],
                      routeName: routeName,
                      type: type,
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text(AppStrings.productsNotAddedYet),
            ),
    );
  }
}
