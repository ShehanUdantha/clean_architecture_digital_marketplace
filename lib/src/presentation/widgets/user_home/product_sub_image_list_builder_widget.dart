import 'product_sub_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product/product_entity.dart';
import '../../blocs/product_details/product_details_bloc.dart';

class ProductSubImageListBuilderWidget extends StatelessWidget {
  final ProductEntity product;
  final int currentIndex;

  const ProductSubImageListBuilderWidget({
    super.key,
    required this.product,
    required this.currentIndex,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: product.subImages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _handleSubImageClick(context, index),
          child: ProductSubImageWidget(
            product: product,
            index: index,
            currentIndex: currentIndex,
          ),
        );
      },
    );
  }

  _handleSubImageClick(BuildContext context, int index) {
    context
        .read<ProductDetailsBloc>()
        .add(ChangeCurrentSubImageNumberEvent(index: index));
  }
}
