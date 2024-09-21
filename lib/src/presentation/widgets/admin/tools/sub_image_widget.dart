import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/network_image_placeholder.dart';

class SubImageWidget extends StatelessWidget {
  const SubImageWidget({
    super.key,
    required this.subImages,
    this.sharedSubImages,
  });

  final List<PlatformFile>? subImages;
  final List? sharedSubImages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          if (subImages != null)
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subImages!.length,
                itemBuilder: (context, index) {
                  return SubImageChip(
                    subImage: subImages![index].path,
                    isFiles: true,
                  );
                },
              ),
            ),
          const SizedBox(
            width: 5,
          ),
          if (sharedSubImages != null)
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sharedSubImages!.length,
                itemBuilder: (context, index) {
                  return SubImageChip(
                    subImage: sharedSubImages![index],
                    isFiles: false,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class SubImageChip extends StatelessWidget {
  const SubImageChip({
    super.key,
    required this.subImage,
    required this.isFiles,
  });

  final dynamic subImage;
  final bool isFiles;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              placeholder: (context, url) => const NetworkImagePlaceholder(),
            ),
    );
  }
}
