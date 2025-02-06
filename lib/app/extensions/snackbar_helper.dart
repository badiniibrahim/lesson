import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesson/app/config/app_colors.dart';

class SnackbarHelper {
  static error({
    required String message,
    String? title,
    double? width,
    SnackPosition? snackPosition,
    EdgeInsets? margin,
  }) {
    Get.rawSnackbar(
      title: title,
      message: message,
      maxWidth: width,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      margin: margin ?? const EdgeInsets.all(16),
      borderRadius: 12.0,
      icon: const Icon(Icons.error, color: Colors.white),
      isDismissible: true,
      backgroundColor: Get.theme.colorScheme.error,
    );
  }

  static success({
    required String message,
    String? title,
    double? width,
    SnackPosition? snackPosition,
    EdgeInsets? margin,
    Color backgroundColor = Colors.green,
  }) {
    return Get.rawSnackbar(
      title: title,
      message: message,
      maxWidth: width,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      margin: margin ?? const EdgeInsets.all(16),
      borderRadius: 12.0,
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Color.fromARGB(255, 39, 134, 103),
      ),
      isDismissible: false,
      backgroundColor: backgroundColor,
      animationDuration: const Duration(milliseconds: 500),
      // backgroundColor: Get.theme.primaryColor,
    );
  }

  static errorSnackBarTopRight({required String message, String? title}) {
    error(
      title: title,
      message: message,
      width: Get.width * .5,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.only(top: 25, left: Get.width * .58),
    );
  }

  static errorSnackBarTopCenter({required String message, String? title}) {
    error(
      title: title,
      message: message,
      width: Get.width * .8,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 25),
    );
  }

  static successSnackBarBottomCenter({required String message, String? title}) {
    success(
      title: title,
      message: message,
      width: Get.width * .5,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 25),
    );
  }

  static successSnackBarTopRight({required String message, String? title}) {
    success(
      title: title,
      message: message,
      //width: Get.width * .5,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.only(top: 0, left: Get.width * .4),
    );
  }

  static successSnackBarTopCenter({
    required String message,
    String? title,
    Color backgroundColor = const Color.fromARGB(255, 39, 134, 103),
  }) {
    success(
      title: title,
      message: message,
      width: Get.width * .5,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 0),
      backgroundColor: backgroundColor,
    );
  }
}

void showCustomSnackbar({
  required String title,
  required String message,
  bool isError = false,
}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: isError ? Colors.red.shade50 : Colors.white,
    colorText: Colors.black87,
    duration: const Duration(seconds: 4),
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    borderRadius: 16,
    icon: Icon(
      isError
          ? Icons.error_outline_rounded
          : Icons.check_circle_outline_rounded,
      color: isError ? Colors.red : AppColors.primary,
      size: 28,
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withAlpha(10),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
    titleText: Text(
      title,
      style: TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isError ? Colors.red : Colors.black87,
      ),
    ),
    messageText: Text(
      message,
      style: const TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 14,
        color: Colors.black54,
      ),
    ),
  );
}
