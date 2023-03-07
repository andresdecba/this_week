import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';

void showSnackBar({
  required String titleText,
  required String messageText,
  Color? color,
}) async {
  await Future.delayed(const Duration(milliseconds: 350));
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    animationDuration: const Duration(milliseconds: 500),
    duration: const Duration(seconds: 15),
    backgroundColor: color ?? blue_primary.withOpacity(0.25),
    borderRadius: 8,
    padding: const EdgeInsets.all(20),
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.all(20.0),
    borderColor: text_bg,
    borderWidth: 2,
    titleText: Text(
      titleText,
      style: kTitleLarge,
    ),
    messageText: Text(
      messageText,
      style: kBodyMedium,
    ),
    icon: const Icon(
      Icons.info,
      size: 30,
    ),
    shouldIconPulse: false,
  );
}
