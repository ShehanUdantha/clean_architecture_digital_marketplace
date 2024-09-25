import '../utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppLists {
  static List<BottomNavigationBarItem> listOfUserBottomNavigationBarItems(
          BuildContext context) =>
      [
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.home),
          label: context.loc.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.shopping_cart),
          label: context.loc.cart,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.user),
          label: context.loc.profile,
        ),
      ];

  static List<BottomNavigationBarItem> listOfAdminBottomNavigationBarItems(
          BuildContext context) =>
      [
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.home),
          label: context.loc.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.category),
          label: context.loc.tools,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.user),
          label: context.loc.profile,
        ),
      ];

  static List<String> listOfMarketingType = [
    'Normal',
    'Featured',
    'Trending',
    'Latest',
  ];

  static List<String> listOfUserType = [
    'All Account',
    'User',
    'Admin',
  ];

  static const Map<String, ThemeMode> themes = {
    'Light': ThemeMode.light,
    'Dark': ThemeMode.dark,
    'System': ThemeMode.system,
  };

  static Map<String, Locale> languages = {
    'English': const Locale('en', 'US'),
    "Spanish": const Locale('es', 'ES'),
    "Chinese": const Locale('zh', 'CN'),
    "French": const Locale('fr', 'FR'),
  };

  static Map<int, String> months(BuildContext context) => {
        1: context.loc.january,
        2: context.loc.february,
        3: context.loc.march,
        4: context.loc.april,
        5: context.loc.may,
        6: context.loc.june,
        7: context.loc.july,
        8: context.loc.august,
        9: context.loc.september,
        10: context.loc.october,
        11: context.loc.november,
        12: context.loc.december,
      };

  static const monthlyPurchaseStatusChartLeftTitles = {
    0: '0',
    20: '20',
    40: '40',
    60: '60',
    80: '80',
    100: '100',
  };

  static monthlyPurchaseStatusChartBottomTitles(BuildContext context) => {
        20: '${context.loc.week} 1',
        40: '${context.loc.week} 2',
        60: '${context.loc.week} 3',
        80: '${context.loc.week} 4',
        100: '${context.loc.week} 5',
      };
}
