// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/theme/theme_bloc.dart';

class SettingsCardWidget extends StatelessWidget {
  final String title;
  final String actionWidgetTitle;
  final Function actionWidgetFunction;

  const SettingsCardWidget({
    super.key,
    required this.title,
    required this.actionWidgetTitle,
    required this.actionWidgetFunction,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Container(
      padding: const EdgeInsets.all(8.0).copyWith(left: 12.0),
      height: Helper.isLandscape(context)
          ? Helper.screeHeight(context) * 0.18
          : Helper.screeHeight(context) * 0.085,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: AppColors.lightDark,
          width: 1.3,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Helper.screeWidth(context) * 0.45,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => actionWidgetFunction(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: AppColors.grey,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              padding: const EdgeInsets.all(5.0).copyWith(right: 0),
              child: Row(
                children: [
                  Text(
                    actionWidgetTitle,
                    style: const TextStyle(
                      color: AppColors.textThird,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textThird,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
