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
}
