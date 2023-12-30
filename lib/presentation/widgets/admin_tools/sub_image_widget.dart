import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';

class SubImageWidget extends StatelessWidget {
  const SubImageWidget({
    super.key,
    required this.subImages,
  });

  final List<PlatformFile>? subImages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subImages?.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8.0),
            height: Helper.screeHeight(context),
            width: Helper.isLandscape(context)
                ? Helper.screeWidth(context) * 0.2
                : Helper.screeWidth(context) * 0.3,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: AppColors.grey,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
              image: DecorationImage(
                image: FileImage(
                  File(subImages![index].path!),
                ),
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }
}
