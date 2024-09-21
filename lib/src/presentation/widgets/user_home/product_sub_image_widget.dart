import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/network_image_placeholder.dart';
import '../../../domain/entities/product/product_entity.dart';

class ProductSubImageWidget extends StatelessWidget {
  final ProductEntity product;
  final int index;
  final int currentIndex;

  const ProductSubImageWidget({
    super.key,
    required this.product,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      height: Helper.screeHeight(context),
      width: Helper.isLandscape(context)
          ? Helper.screeWidth(context) * 0.25
          : Helper.screeWidth(context) * 0.28,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: product.subImages[index],
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            placeholder: (context, url) => const NetworkImagePlaceholder(),
          ),
          index != currentIndex
              ? Container(
                  decoration: const BoxDecoration(
                    color: AppColors.mediumDarkGrey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
