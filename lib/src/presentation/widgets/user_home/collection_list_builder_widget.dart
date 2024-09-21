import '../../../domain/entities/product/product_entity.dart';
import 'collection_product_card_widget.dart';
import 'package:flutter/material.dart';

class CollectionListBuilderWidget extends StatelessWidget {
  final List<ProductEntity> productsList;

  const CollectionListBuilderWidget({
    super.key,
    required this.productsList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: OrientationBuilder(
        builder: (context, orientation) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              return CollectionProductCardWidget(
                product: productsList[index],
              );
            },
          );
        },
      ),
    );
  }
}
