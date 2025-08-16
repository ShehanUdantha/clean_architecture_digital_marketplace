import 'dart:io';

import '../constants/error_messages.dart';
import '../constants/variable_names.dart';
import '../services/notification_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import '../services/service_locator.dart' as locator;

import '../../config/routes/router.dart';
import '../../domain/entities/category/category_entity.dart';
import '../../domain/entities/product/product_entity.dart';
import '../constants/lists.dart';
import '../../core/utils/extension.dart';

class Helper {
  static double screeHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screeWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
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
    return result?.files.first;
  }

  static Future<List<PlatformFile>?> multipleImagePick() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    return result?.files.map((e) => e).toList();
  }

  static Future<PlatformFile?> zipFilePick() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    return result?.files.first;
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

  static String formatDate(DateTime date) {
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

  static void getNotificationPermission() async {
    await Permission.notification.isDenied.then(
      (value) {
        if (value) {
          Permission.notification.request();
        }
      },
    );
  }

  static String formatTimeago(DateTime date) {
    return timeago.format(date);
  }

  static void displayBottomSheet(BuildContext context, Widget childWidget) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return childWidget;
      },
    );
  }

  static int getWeekFromDay(int day) {
    return ((day - 1) ~/ 7) + 1;
  }

  static Future<Directory?> createFolder() async {
    try {
      Directory baseDir;

      if (Platform.isIOS) {
        baseDir = await getApplicationDocumentsDirectory();
      } else {
        baseDir = Directory('/storage/emulated/0/Download');

        if (!await baseDir.exists()) {
          final fallbackDir = await getExternalStorageDirectory();
          if (fallbackDir == null) {
            return null;
          }
          baseDir = fallbackDir;
        }
      }

      final Directory targetDir = Directory('${baseDir.path}/Pixelcart');

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      return targetDir;
    } catch (e) {
      debugPrint("Error creating folder: $e");
      return null;
    }
  }

  static String modifyTheFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').toLowerCase();
  }

  static Future<void> downloadFile(String? fileUrl, String fileName) async {
    final fileDirectory = await createFolder();
    final notificationService = locator.sl<NotificationService>();

    final modifiedFileName = modifyTheFileName(fileName);

    if (fileUrl != null && fileUrl != '') {
      if (fileDirectory != null) {
        final filePath = '${fileDirectory.path}/$modifiedFileName.zip';
        final file = File(filePath);

        try {
          final request = http.Request('GET', Uri.parse(fileUrl));
          final response = await request.send();

          if (response.statusCode == 200) {
            final contentLength = response.contentLength ?? 0;
            int downloaded = 0;
            int lastPercent = 0;

            final sink = file.openWrite();

            await for (var chunk in response.stream) {
              downloaded += chunk.length;
              sink.add(chunk);

              final percent = ((downloaded / contentLength) * 100).round();
              if (percent != lastPercent) {
                await notificationService.showProgressNotification(
                  title:
                      '${rootNavigatorKey.currentContext?.loc.downloading ?? AppErrorMessages.downloading} $fileName',
                  progress: percent,
                  fileName: fileName,
                );
                lastPercent = percent;
              }
            }

            await sink.flush();
            await sink.close();

            await notificationService.showInstantNotification(
              title: rootNavigatorKey.currentContext?.loc.downloadComplete ??
                  AppErrorMessages.downloadComplete,
              body:
                  '$fileName ${rootNavigatorKey.currentContext?.loc.downloadedSuccessfully ?? AppErrorMessages.downloadedSuccessfully} $fileName.',
              payload: AppVariableNames.downloadPayload,
            );
          } else {
            await notificationService.showInstantNotification(
              title: rootNavigatorKey.currentContext?.loc.downloadFailed ??
                  AppErrorMessages.downloadFailed,
              body:
                  '${rootNavigatorKey.currentContext?.loc.couldNotDownload ?? AppErrorMessages.couldNotDownload} $fileName.',
              payload: AppVariableNames.downloadPayload,
            );
          }
        } catch (e) {
          debugPrint("Download error: $e");
          await notificationService.showInstantNotification(
            title: rootNavigatorKey.currentContext?.loc.downloadFailed ??
                AppErrorMessages.downloadFailed,
            body:
                '${rootNavigatorKey.currentContext?.loc.anErrorOccurredWhileDownloading ?? AppErrorMessages.anErrorOccurredWhileDownloading} $fileName.',
            payload: AppVariableNames.downloadPayload,
          );
        }
      } else {
        showSnackBar(
            rootNavigatorKey.currentContext!,
            rootNavigatorKey
                    .currentContext?.loc.downloadFileDirectoryNotFound ??
                AppErrorMessages.downloadFileDirectoryNotFound);
      }
    } else {
      showSnackBar(
          rootNavigatorKey.currentContext!,
          rootNavigatorKey.currentContext?.loc.downloadURLNotFound ??
              AppErrorMessages.downloadURLNotFound);
    }
  }

  static bool checkIsDarkMode(BuildContext context, ThemeMode themeMode) {
    if (themeMode == ThemeMode.system) {
      final brightness = MediaQuery.of(context).platformBrightness;
      return brightness == Brightness.dark;
    }

    return themeMode == ThemeMode.dark;
  }
}
