import 'dart:io';

import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';

import '../utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_icon_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/product/product_entity.dart';
import 'network_image_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';
import '../utils/helper.dart';

class ProductLinearCardWidget extends StatelessWidget {
  final bool isEdit;
  final bool isAction;
  final Function? deleteFunction;
  final Function? editFunction;
  final Function? downloadFunction;
  final ProductEntity product;

  const ProductLinearCardWidget({
    super.key,
    this.isEdit = true,
    this.isAction = true,
    this.deleteFunction,
    this.editFunction,
    this.downloadFunction,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = Helper.checkIsDarkMode(context, state.themeMode);

        return Column(
          children: [
            Container(
              height: Helper.isLandscape(context)
                  ? Helper.screeHeight(context) * 0.4
                  : isAction
                      ? Helper.screeHeight(context) * 0.175
                      : Helper.screeHeight(context) * 0.15,
              width: Helper.screeWidth(context),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    height: Helper.screeHeight(context),
                    width: Helper.isLandscape(context)
                        ? Helper.screeWidth(context) *
                            (Platform.isAndroid ? 0.3 : 0.2)
                        : Helper.screeWidth(context) * 0.35,
                    child: CachedNetworkImage(
                      imageUrl: product.coverImage,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const NetworkImagePlaceholder(),
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  SizedBox(
                    width: Helper.isLandscape(context)
                        ? Helper.screeWidth(context) * 0.6
                        : Helper.screeWidth(context) * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? AppColors.textWhite
                                : AppColors.textFourth,
                            fontSize: 15,
                          ),
                          maxLines: Helper.isLandscape(context) ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          product.category,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '\$${double.parse(product.price).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? AppColors.textFifth
                                : AppColors.textPrimary,
                            fontSize: 17,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        isAction
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BaseIconButtonWidget(
                                    function: () => deleteFunction!(),
                                    icon: const Icon(
                                      Iconsax.bag,
                                      size: 18,
                                      color: AppColors.lightRed,
                                    ),
                                    size: 35.0,
                                  ),
                                  isEdit
                                      ? Row(
                                          children: [
                                            const SizedBox(
                                              width: 16.0,
                                            ),
                                            BaseIconButtonWidget(
                                              function: () => editFunction!(),
                                              icon: const Icon(
                                                Iconsax.edit_2,
                                                size: 18,
                                                color: AppColors.lightGreen,
                                              ),
                                              size: 35.0,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              )
                            : const SizedBox(),
                        downloadFunction != null
                            ? GestureDetector(
                                onTap: () => downloadFunction!(),
                                child: Text(
                                  context.loc.download,
                                  style: const TextStyle(
                                    color: AppColors.lightBlue,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.lightGrey,
            ),
          ],
        );
      },
    );
  }
}
