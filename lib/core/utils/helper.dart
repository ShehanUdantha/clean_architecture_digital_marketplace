import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/category/category_entity.dart';
import '../../domain/entities/product/product_entity.dart';
import '../constants/lists.dart';

class Helper {
  static double screeHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screeWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static List<DropdownMenuItem> createMarketingDropDownList() {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < AppLists.listOfMarketingType.length; i++) {
      items.add(
        DropdownMenuItem(
          value: (i + 1).toString(),
          child: Text(AppLists.listOfMarketingType[i]),
        ),
      );
    }
    return items;
  }

  static List<DropdownMenuItem> createCategoryDropDownList(
    List<CategoryEntity> list,
  ) {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < list.length; i++) {
      items.add(
        DropdownMenuItem(
          value: (i + 1).toString(),
          child: Text(list[i].name),
        ),
      );
    }
    return items;
  }

  static Future<PlatformFile?> imagePick() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    return result!.files.first;
  }

  static Future<List<PlatformFile>?> multipleImagePick() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    return result!.files.map((e) => e).toList();
  }

  static Future<PlatformFile?> zipFilePick() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
    );
    return result!.files.first;
  }

  static List<Uint8List> subImagesList(List<PlatformFile> files) {
    final List<Uint8List> subImagesUrls = [];

    for (final item in files) {
      subImagesUrls.add(item.bytes!);
    }

    return subImagesUrls;
  }

  static List<String> createCategoryHorizontalList(
    List<CategoryEntity> list,
  ) {
    List<String> items = [
      "All Items",
    ];
    for (int i = 0; i < list.length; i++) {
      items.add(list[i].name);
    }
    return items;
  }

  static double calculateSubTotal(List<ProductEntity> list) {
    double subTotal = 0.0;
    for (int i = 0; i < list.length; i++) {
      subTotal += double.parse(list[i].price);
    }
    return subTotal;
  }

  // stripe fee
  static double calculateTransactionFee(double subTotal) {
    return subTotal * 0.037;
  }

  static String formatDate(var date) {
    return '${DateFormat.yMMMEd('en_US').format(date)} - ${DateFormat.Hms().format(date)}';
  }

  static Future<bool> storagePermissionRequest() async {
    PermissionStatus result;
    result = await Permission.storage.request();
    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
