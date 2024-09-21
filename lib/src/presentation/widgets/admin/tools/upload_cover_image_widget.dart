// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/network_image_placeholder.dart';
import '../../../blocs/theme/theme_bloc.dart';

class UploadCoverImageWidget extends StatelessWidget {
  final PlatformFile? coverImage;
  final String? sharedCoverImage;

  const UploadCoverImageWidget({
    super.key,
    required this.coverImage,
    this.sharedCoverImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Helper.isLandscape(context)
          ? Helper.screeHeight(context) * 0.55
          : Helper.screeHeight(context) * 0.25,
      decoration: const BoxDecoration(
        color: AppColors.lightDark,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: coverImage != null
          ? Container(
              decoration: BoxDecoration(
                color: AppColors.lightDark,
                borderRadius: const BorderRadius.all(
                  Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: FileImage(
                    File(coverImage!.path!),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : sharedCoverImage != null
              ? Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: sharedCoverImage!,
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
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: const CoverImageUpdateTextWidget(
                        needToChangeColor: false,
                      ),
                    ),
                  ],
                )
              : const CoverImageUpdateTextWidget(),
    );
  }
}

class CoverImageUpdateTextWidget extends StatelessWidget {
  final bool needToChangeColor;

  const CoverImageUpdateTextWidget({
    super.key,
    this.needToChangeColor = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.document_upload,
            color: needToChangeColor
                ? isDarkMode
                    ? AppColors.textFifth
                    : AppColors.textPrimary
                : AppColors.textPrimary,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            context.loc.uploadCoverImage,
            style: TextStyle(
              color: needToChangeColor
                  ? isDarkMode
                      ? AppColors.textFifth
                      : AppColors.textPrimary
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
