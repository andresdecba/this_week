import 'package:flutter/material.dart';
import 'package:get/get.dart';

// colors
// ignore: constant_identifier_names
const grey_bg = Color(0xFFE8E8E8);
const disabled_task_bg = Color.fromARGB(255, 206, 206, 206);
const enabled_grey = Color(0xFF626262);
const disabled_grey = Color(0xFFA6A6A6);
const status_task_pending = Color.fromARGB(255, 248, 228, 125);
const status_task_in_progress = Color.fromARGB(255, 56, 149, 255);
const status_task_done = Color.fromARGB(255, 138, 173, 131);
const yellow_primary = Color(0xFFFFC700);
const yellow_header = Color.fromARGB(255, 253, 243, 201);
const withe_bg = Color(0xFFFFFFFF);
const black_bg = Color(0xFF000000);
const text_bg = Color(0xFF000000);
const warning = Color(0xFFD30000);
const blue_primary = Color(0xFF0075FF);
const icons_bg = Color(0xFF262626);
const green_info = Color.fromARGB(255, 125, 252, 103);


// titles
final kTitleLarge = Theme.of(Get.context!).textTheme.titleLarge!;
final kTitleMedium = Theme.of(Get.context!).textTheme.titleMedium!;
final kTitleSmall = Theme.of(Get.context!).textTheme.titleSmall!;
final kHeadlineLarge = Theme.of(Get.context!).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold);
// bodies
final kBodySmall = Theme.of(Get.context!).textTheme.bodySmall!;
final kBodyMedium = Theme.of(Get.context!).textTheme.bodyMedium!;
final kBodyLarge = Theme.of(Get.context!).textTheme.bodyLarge!;
// labels
final kLabelMedium = Theme.of(Get.context!).textTheme.labelMedium!;
final kLabelLarge = Theme.of(Get.context!).textTheme.labelLarge!;
// notification bar
final TextStyle noDateTxtStyle = kTitleSmall.copyWith(color: disabled_grey, fontStyle: FontStyle.italic);
final TextStyle dateTxtStyle = kTitleMedium.copyWith(color: enabled_grey);
final TextStyle newDateTxtStyle = kTitleMedium.copyWith(color: blue_primary);

// textfield style
InputDecoration customInputDecoration({
  required bool hasBorder,
  required String label,
  required String hintText,
  required VoidCallback clearText,
  required bool isEnabled,
  Color? borderColor,
}) {
  return InputDecoration(
    //label: Text(label),
    contentPadding: isEnabled ? const EdgeInsets.all(10) : EdgeInsets.zero,
    isDense: true,
    border: hasBorder == true ? const OutlineInputBorder() : InputBorder.none,
    labelStyle: const TextStyle(color: disabled_grey),
    alignLabelWithHint: true,
    hintText: hintText,
    hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabled_grey),
    filled: isEnabled,
    fillColor: withe_bg.withOpacity(0.4),
    suffixIcon: hasBorder == true
        ? IconButton(
            icon: const Icon(
              Icons.clear,
              color: enabled_grey,
            ), // clear text
            onPressed: clearText,
          )
        : null,
    counterStyle: const TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 10,
      height: double.minPositive,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor ?? blue_primary,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor ?? status_task_in_progress,
      ),
    ),
  );
}
