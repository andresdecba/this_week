import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';

void showSnackBar({
  required String titleText,
  required String messageText,
  Color? color,
  double? marginFromBottom,
}) async {
  await Future.delayed(const Duration(milliseconds: 350));
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    animationDuration: const Duration(milliseconds: 500),
    duration: const Duration(seconds: 10),
    backgroundColor: color ?? blue_primary.withOpacity(0.5),
    padding: const EdgeInsets.all(20),
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
    borderRadius: 0,
    //borderColor: blue_primary,
    //borderWidth: 1,
    titleText: Text(
      titleText,
      style: kTitleMedium,
    ),
    messageText: Text(
      messageText,
      style: kBodySmall.copyWith(fontStyle: FontStyle.italic),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    icon: const Icon(
      Icons.info,
      size: 30,
      //color: blue_primary,
    ),
    shouldIconPulse: false,
    dismissDirection: DismissDirection.horizontal,
    isDismissible: true,
    barBlur: 5,
  );
}
