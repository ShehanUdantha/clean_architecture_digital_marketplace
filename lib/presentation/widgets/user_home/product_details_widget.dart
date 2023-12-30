import 'package:Pixelcart/core/utils/extension.dart';
import 'package:Pixelcart/presentation/blocs/auth/auth_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/strings.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../blocs/cart/cart_bloc.dart';
import 'product_sub_image_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/widgets/base_icon_button_widget.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../../core/widgets/elevated_loading_button_widget.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/product_details/product_details_bloc.dart';

class ProductDetailsWidget extends StatelessWidget {
  final ProductEntity product;
  final Function backFunction;

  const ProductDetailsWidget({
    super.key,
    required this.product,
    required this.backFunction,
  });

  @override
  Widget build(BuildContext context) {
    final productDetailsState = context.watch<ProductDetailsBloc>().state;
    final authState = context.watch<AuthBloc>().state;

    return Stack(
      children: [
        ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: Helper.isLandscape(context)
                  ? Helper.screeHeight(context) * 0.59
                  : Helper.screeHeight(context) * 0.795,
              child: ListView(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: product.subImages[
                            productDetailsState.currentSubImageNumber],
                        imageBuilder: (context, imageProvider) => Container(
                          height: Helper.isLandscape(context)
                              ? Helper.screeHeight(context) * 1.2
                              : Helper.screeHeight(context) * 0.42,
                          width: Helper.screeWidth(context),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => SizedBox(
                          height: Helper.isLandscape(context)
                              ? Helper.screeHeight(context) * 1.2
                              : Helper.screeHeight(context) * 0.42,
                          width: Helper.screeWidth(context),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: BaseIconButtonWidget(
                          function: () => backFunction(),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 6.0,
                          ),
                          decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _favoriteButton(context),
                                child: SizedBox(
                                  child: product.likes
                                          .contains(authState.user!.uid)
                                      ? const Icon(
                                          Icons.favorite,
                                          color: AppColors.lightRed,
                                        )
                                      : const Icon(
                                          Icons.favorite_outline,
                                          color: AppColors.secondWhite,
                                        ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                product.likes.length.toString(),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0).copyWith(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          product.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          product.category,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Iconsax.star1,
                              color: Colors.amber,
                            ),
                            Icon(
                              Iconsax.star1,
                              color: Colors.amber,
                            ),
                            Icon(
                              Iconsax.star1,
                              color: Colors.amber,
                            ),
                            Icon(
                              Iconsax.star1,
                              color: Colors.amber,
                            ),
                            Icon(
                              Iconsax.star1,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '5.0',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '(76 reviews)',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: AppColors.textThird,
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          height: Helper.isLandscape(context)
                              ? Helper.screeHeight(context) * 0.3
                              : Helper.screeHeight(context) * 0.11,
                          width: Helper.screeWidth(context),
                          child: ProductSubImageListBuilderWidget(
                            product: product,
                            currentIndex:
                                productDetailsState.currentSubImageNumber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
        Positioned(
          bottom: 11.2,
          child: SizedBox(
            width: Helper.screeWidth(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
                listener: (context, state) {
                  if (state.cartedStatus == BlocStatus.error) {
                    Helper.showSnackBar(
                      context,
                      state.cartedMessage,
                    );
                  }
                  if (state.favoriteStatus == BlocStatus.error) {
                    Helper.showSnackBar(
                      context,
                      state.favoriteMessage,
                    );
                  }

                  if (state.cartedStatus == BlocStatus.success) {
                    if (state.cartedMessage == CURDTypes.add.curd) {
                      Helper.showSnackBar(
                        context,
                        AppStrings.productAddedToCart,
                      );
                      context
                          .read<ProductDetailsBloc>()
                          .add(GetCartedItemsEvent());
                      context
                          .read<CartBloc>()
                          .add(UpdateCartedProductsDetailsByIdEvent());
                    }
                    if (state.cartedMessage == CURDTypes.remove.curd) {
                      Helper.showSnackBar(
                        context,
                        AppStrings.productRemovedFromCart,
                      );
                      context
                          .read<ProductDetailsBloc>()
                          .add(GetCartedItemsEvent());
                      context
                          .read<CartBloc>()
                          .add(UpdateCartedProductsDetailsByIdEvent());
                    }
                    context
                        .read<ProductDetailsBloc>()
                        .add(SetProductDetailsToDefaultEvent());
                  }

                  if (state.favoriteStatus == BlocStatus.success) {
                    if (state.productEntity.likes
                        .contains(authState.user!.uid)) {
                      Helper.showSnackBar(
                        context,
                        AppStrings.addedToFavorite,
                      );
                    } else {
                      Helper.showSnackBar(
                        context,
                        AppStrings.removeFromFavorite,
                      );
                    }
                    context
                        .read<ProductDetailsBloc>()
                        .add(SetProductFavoriteToDefaultEvent());
                  }
                },
                builder: (context, state) {
                  if (state.cartedStatus == BlocStatus.loading) {
                    return const ElevatedLoadingButtonWidget();
                  }

                  return state.cartedItems.contains(product.id)
                      ? ElevatedButtonWidget(
                          title: const Text(
                            'Remove From Cart',
                            style: TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                          function: () => _handleRemoveFromCartButton(
                            context,
                            product.id!,
                          ),
                        )
                      : ElevatedButtonWidget(
                          title: Text(
                            'Add To Cart | \u{20B9}${product.price}',
                            style: const TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                          function: () => _handleAddToCartButton(
                            context,
                            product.id!,
                          ),
                        );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _handleAddToCartButton(BuildContext context, String id) {
    context.read<ProductDetailsBloc>().add(AddProductToCartEvent(id: id));
  }

  _handleRemoveFromCartButton(BuildContext context, String id) {
    context.read<ProductDetailsBloc>().add(RemoveProductFromCartEvent(id: id));
  }

  _favoriteButton(BuildContext context) {
    context.read<ProductDetailsBloc>().add(AddFavoriteToProductEvent());
  }
}
