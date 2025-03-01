import 'dart:io';

import '../../../../core/widgets/base_icon_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/network_image_placeholder.dart';

class SubImageChipWidget extends StatelessWidget {
  const SubImageChipWidget({
    super.key,
    required this.subImage,
    required this.isFiles,
    required this.removeFunction,
  });

  final dynamic subImage;
  final bool isFiles;
  final Function removeFunction;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8.0),
          height: Helper.screeHeight(context),
          width: Helper.isLandscape(context)
              ? Helper.screeWidth(context) * 0.2
              : Helper.screeWidth(context) * 0.3,
          child: isFiles
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppColors.grey,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    image: DecorationImage(
                      image: FileImage(File(subImage)),
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: subImage,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppColors.grey,
                      ),
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
        Positioned(
          top: 1,
          right: 9,
          child: BaseIconButtonWidget(
            function: () => removeFunction(),
            icon: const Icon(
              Iconsax.bag,
              size: 15,
              color: AppColors.lightRed,
            ),
            size: 30.0,
          ),
        ),
      ],
    );
  }
}
