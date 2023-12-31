import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/routes_name.dart';
import '../../../domain/entities/product/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';

class GridProductCard extends StatelessWidget {
  final ProductEntity product;
  final String routeName;
  final String? type;

  const GridProductCard({
    super.key,
    required this.product,
    required this.routeName,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleMoveProductViewPage(
        context,
        product.id!,
        routeName,
        type,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.lightDark,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: product.coverImage,
              imageBuilder: (context, imageProvider) => Container(
                height: Helper.isLandscape(context)
                    ? Helper.screeHeight(context) * 0.48
                    : Helper.screeHeight(context) * 0.18,
                width: Helper.screeWidth(context),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => SizedBox(
                height: Helper.isLandscape(context)
                    ? Helper.screeHeight(context) * 0.48
                    : Helper.screeHeight(context) * 0.18,
                width: Helper.screeWidth(context),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    width: Helper.screeWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\u{20B9}${double.parse(product.price).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 20,
                              color: AppColors.lightRed,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              product.likes.length.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleMoveProductViewPage(
    BuildContext context,
    String id,
    String name,
    String? type,
  ) {
    context.goNamed(
      AppRoutes.productViewPageName,
      queryParameters: {
        'route': name,
        'id': id,
        'type': type,
      },
    );
  }
}
