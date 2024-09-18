import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppLists {
  static const List<BottomNavigationBarItem>
      listOfUserBottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Iconsax.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Iconsax.shopping_cart),
      label: 'Cart',
    ),
    BottomNavigationBarItem(
      icon: Icon(Iconsax.user),
      label: 'Profile',
    ),
  ];

  static const List<BottomNavigationBarItem>
      listOfAdminBottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Iconsax.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Iconsax.category),
      label: 'Tools',
    ),
    BottomNavigationBarItem(
      icon: Icon(Iconsax.user),
      label: 'Profile',
    ),
  ];

  static const List<String> listOfMarketingType = [
    'Normal',
    'Featured',
    'Trending',
    'Latest',
  ];

  static const Map<String, ThemeMode> themes = {
    'Light': ThemeMode.light,
    'Dark': ThemeMode.dark,
    'System': ThemeMode.system,
  };
}
