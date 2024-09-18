import '../../core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary,
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.textSecondary,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.secondary,
      selectionHandleColor: AppColors.secondary,
    ),
    textTheme: ThemeData().textTheme.apply(
          fontFamily: 'Poppins',
        ),
    bottomSheetTheme: const BottomSheetThemeData().copyWith(
      backgroundColor: AppColors.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData().copyWith(
      backgroundColor: AppColors.secondary,
      contentTextStyle: const TextStyle(
        color: AppColors.textFifth,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkPrimary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkPrimary,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),
    textTheme: ThemeData().textTheme.apply(
          fontFamily: 'Poppins',
        ),
    bottomSheetTheme: const BottomSheetThemeData().copyWith(
      backgroundColor: AppColors.darkPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData().copyWith(
      backgroundColor: AppColors.primary,
      contentTextStyle: const TextStyle(
        color: AppColors.textPrimary,
      ),
    ),
  );
}
