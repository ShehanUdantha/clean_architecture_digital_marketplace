import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';

class UploadCoverImageWidget extends StatelessWidget {
  final PlatformFile? coverImage;

  const UploadCoverImageWidget({
    super.key,
    required this.coverImage,
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
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.document_upload,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Upload Cover Image',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
