import 'package:flutter/material.dart';
import 'package:get/get.dart';

// colors
// ignore: constant_identifier_names
const grey_background = Color(0xFFFFFBFE); //background: Color(0xFFFFFBFE)
const disabledTaskBg = Color.fromARGB(255, 206, 206, 206);
const enabledGrey = Color(0xFF626262);
const disabledGrey = Color(0xFFA6A6A6);
const softGrey = Color.fromARGB(255, 216, 216, 216);
const statusTaskPending = Color.fromARGB(255, 248, 228, 125);
const statusTaskInProgress = Color.fromARGB(255, 56, 149, 255);
const statusTaskDone = Color.fromARGB(255, 138, 173, 131);
const yellowPrimary = Color(0xFFFFC700);
const header = Color.fromARGB(255, 201, 241, 253);
const whiteBg = Color(0xFFFFFFFF);
const blackBg = Color(0xFF000000);
const appBarLogo = Color(0xFF000000);
const textBg = Color(0xFF000000);
const warning = Color(0xFFD30000);
const bluePrimary = Color(0xFF0075FF);

const iconsBg = Color(0xFF262626);
const greenInfo = Color.fromARGB(255, 125, 252, 103);

final splashColorButtons = yellowPrimary.withOpacity(0.5);

// task description
final kViewTaskDescripton = Theme.of(Get.context!).textTheme.titleLarge!.copyWith(fontSize: 26);
final myChipBg = softGrey.withOpacity(0.5);
const myChipText = enabledGrey;

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
final kLabelSmall = Theme.of(Get.context!).textTheme.labelSmall!;
final kLabelMedium = Theme.of(Get.context!).textTheme.labelMedium!;
final kLabelLarge = Theme.of(Get.context!).textTheme.labelLarge!;
// notification bar
final TextStyle noDateTxtStyle = kTitleSmall.copyWith(color: disabledGrey, fontStyle: FontStyle.italic);
final TextStyle dateTxtStyle = kTitleMedium.copyWith(color: enabledGrey);
final TextStyle newDateTxtStyle = kTitleMedium.copyWith(color: bluePrimary);

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
    contentPadding: isEnabled ? const EdgeInsets.all(10) : EdgeInsets.zero,
    isDense: true,
    border: isEnabled == true ? const OutlineInputBorder() : InputBorder.none,
    alignLabelWithHint: true,
    hintText: hintText,
    hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
    labelStyle: const TextStyle(color: bluePrimary),
    filled: isEnabled,
    fillColor: whiteBg.withOpacity(0.4),
    suffixIcon: isEnabled == true
        ? IconButton(
            icon: const Icon(
              Icons.clear,
              color: enabledGrey,
            ), // clear text
            onPressed: clearText,
          )
        : null,
    counterText: isEnabled ? null : "",
    counterStyle: const TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 10,
      height: double.minPositive,
    ),
    enabledBorder: isEnabled == true
        ? const OutlineInputBorder(
            borderSide: BorderSide(color: bluePrimary),
          )
        : null,
    focusedBorder: isEnabled == true
        ? const OutlineInputBorder(
            borderSide: BorderSide(color: bluePrimary),
          )
        : null,
  );
}
