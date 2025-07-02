import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:like_button/like_button.dart';

import '../../../core/utils/extension.dart';
import '../../../core/widgets/circular_loading_indicator.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/user_home/user_home_bloc.dart';
import 'product_sub_image_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final uid = context.read<AuthBloc>().state.user?.uid;

    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, themeState) {
        final isDarkMode =
            Helper.checkIsDarkMode(context, themeState.themeMode);

        return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          buildWhen: (previous, current) =>
              previous.currentSubImageNumber != current.currentSubImageNumber,
          builder: (context, productDetailsState) {
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
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                                  child: const CircularLoadingIndicator(),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  child: LikeButton(
                                    onTap: (value) =>
                                        _favoriteButton(context, value),
                                    isLiked: product.likes.contains(uid),
                                    likeCount: product.likes.length,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(16.0).copyWith(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  product.productName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: isDarkMode
                                        ? AppColors.textFifth
                                        : AppColors.textPrimary,
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
                                    currentIndex: productDetailsState
                                        .currentSubImageNumber,
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
                      child:
                          BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
                        listenWhen: (previous, current) =>
                            previous.cartedStatus != current.cartedStatus ||
                            previous.favoriteStatus != current.favoriteStatus,
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
                                context.loc.productAddedToCart,
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
                                context.loc.productRemovedFromCart,
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
                            if (state.productEntity.likes.contains(uid)) {
                              Helper.showSnackBar(
                                context,
                                context.loc.addedToFavorite,
                              );
                            } else {
                              Helper.showSnackBar(
                                context,
                                context.loc.removeFromFavorite,
                              );
                            }

                            context.read<UserHomeBloc>()
                              ..add(GetFeaturedListEvent())
                              ..add(GetTrendingListEvent())
                              ..add(GetLatestListEvent());

                            context
                                .read<ProductDetailsBloc>()
                                .add(SetProductFavoriteToDefaultEvent());
                          }
                        },
                        buildWhen: (previous, current) =>
                            previous.cartedStatus != current.cartedStatus ||
                            previous.cartedItems != current.cartedItems,
                        builder: (context, state) {
                          if (state.cartedStatus == BlocStatus.loading) {
                            return const ElevatedLoadingButtonWidget();
                          }

                          return state.cartedItems.contains(product.id)
                              ? ElevatedButtonWidget(
                                  title: context.loc.removeFromCart,
                                  function: () => _handleRemoveFromCartButton(
                                    context,
                                    product.id!,
                                  ),
                                )
                              : ElevatedButtonWidget(
                                  title:
                                      '${context.loc.addToCart} | \$${double.parse(product.price).toStringAsFixed(2)}',
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
          },
        );
      },
    );
  }

  void _handleAddToCartButton(BuildContext context, String id) {
    context.read<ProductDetailsBloc>().add(AddProductToCartEvent(id: id));
  }

  void _handleRemoveFromCartButton(BuildContext context, String id) {
    context.read<ProductDetailsBloc>().add(RemoveProductFromCartEvent(id: id));
  }

  Future<bool> _favoriteButton(BuildContext context, bool value) async {
    context.read<ProductDetailsBloc>().add(AddFavoriteToProductEvent());
    return !value;
  }
}
