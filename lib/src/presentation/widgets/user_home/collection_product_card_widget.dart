import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/routes_name.dart';
import '../../../core/widgets/circular_loading_indicator.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/theme/theme_bloc.dart';

class CollectionProductCardWidget extends StatelessWidget {
  final ProductEntity product;

  const CollectionProductCardWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return GestureDetector(
      onTap: () => _handleMoveProductViewPage(
        context,
        product.id!,
      ),
      child: Container(
        // should have hero animation
        margin: const EdgeInsets.only(right: 8.0),
        width: Helper.isLandscape(context)
            ? Helper.screeWidth(context) * 0.45
            : Helper.screeWidth(context) * 0.6,
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
                    ? Helper.screeHeight(context) * 0.5
                    : Helper.screeHeight(context) * 0.23,
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
                    ? Helper.screeHeight(context) * 0.5
                    : Helper.screeHeight(context) * 0.23,
                width: Helper.screeWidth(context),
                child: const CircularLoadingIndicator(),
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
                    style: TextStyle(
                      fontSize: 14.5,
                      color: isDarkMode
                          ? AppColors.textFifth
                          : AppColors.textPrimary,
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
                          '\$${double.parse(product.price).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode
                                ? AppColors.textSecondary
                                : AppColors.secondary,
                          ),
                        ),
                        if (product.likes.isNotEmpty)
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode
                                      ? AppColors.textSecondary
                                      : AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleMoveProductViewPage(BuildContext context, String id) {
    context.goNamed(
      AppRoutes.productViewPageName,
      queryParameters: {
        'route': BackPageTypes.home.page,
        'id': id,
      },
    );
  }
}
