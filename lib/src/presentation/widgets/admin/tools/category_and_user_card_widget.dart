// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helper.dart';
import '../../../blocs/theme/theme_bloc.dart';

class CategoryAndUserCardWidget extends StatelessWidget {
  final String title;
  final String? type;
  final Function? function;

  const CategoryAndUserCardWidget({
    super.key,
    required this.title,
    this.type,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
          height: Helper.isLandscape(context)
              ? Helper.screeHeight(context) * 0.15
              : Helper.screeHeight(context) * 0.08,
          width: Helper.screeWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Helper.screeWidth(context) * 0.8,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.textFifth
                            : AppColors.textPrimary,
                        fontSize: 14.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  type != null
                      ? SizedBox(
                          width: Helper.screeWidth(context) * 0.8,
                          child: Text(
                            type!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              function != null
                  ? GestureDetector(
                      onTap: () => function!() ?? () {},
                      child: const Icon(
                        Iconsax.bag,
                        size: 18,
                        color: AppColors.lightRed,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        const Divider(
          color: AppColors.lightGrey,
        ),
      ],
    );
  }
}
