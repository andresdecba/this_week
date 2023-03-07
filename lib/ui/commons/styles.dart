import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

////// used ////////

// colors
// ignore: constant_identifier_names
const grey_bg = Color(0xFFE8E8E8);
const enabled_grey = Color(0xFF626262);
const disabled_grey = Color(0xFFA6A6A6);
const status_task_pending = Color(0xFFDBC75D);
const status_task_in_progress = Color(0xFFFF7A00);
const status_task_done = Color(0xFF117600);
const yellow_primary = Color(0xFFFFC700);
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
// bodies
final kBodySmall = Theme.of(Get.context!).textTheme.bodySmall!;
final kBodyMedium = Theme.of(Get.context!).textTheme.bodyMedium!;
final kBodyLarge = Theme.of(Get.context!).textTheme.bodyText1!;
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
    hintStyle: const TextStyle(color: disabled_grey, fontStyle: FontStyle.italic),
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

////////////////////////// BORRAR /////////////////////////

final boxDecoration = BoxDecoration(
  color: Colors.grey[350],
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

/////// TEXT STYLES //////
// const regular_txt = TextStyle(
//   fontStyle: FontStyle.normal,
//   fontSize: 60,
//   color: text_color,
// );

// const small_txt = TextStyle(
//   fontStyle: FontStyle.normal,
//   fontSize: 40,
//   color: text_color,
// );

// const titles_txt = TextStyle(
//   fontStyle: FontStyle.normal,
//   fontSize: 80,
//   color: text_color,
// );

// ///
const titleTextStyle = TextStyle(
  fontStyle: FontStyle.italic,
  color: Colors.blueGrey,
);

/// THEME ///

//  EJEMPLO DE COMO USAR:
//  Text(
//    'Muestra de texto',
//    style: Theme.of(context).textTheme.bodySmall,
//  ),

// final themeData = ThemeData(
//   appBarTheme: const AppBarTheme(
//     backgroundColor: yellow_primary,
//   ),
//   iconTheme: const IconThemeData(
//     color: text_color,
//   ),
//   textTheme: const TextTheme(
//     bodyMedium: TextStyle(
//       fontSize: 14,
//       color: text_color,
//     ),
//     bodySmall: TextStyle(
//       fontSize: 32,
//       color: warning,
//     ),
//     // titleMedium: TextStyle(
//     //   fontSize: 40,
//     //   color: status_task_in_progress,
//     // ),
//     labelMedium: TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//       fontStyle: FontStyle.italic,
//       color: blue_primary,
//     ),
//     labelSmall: TextStyle(
//       fontSize: 12,
//       fontStyle: FontStyle.italic,
//       color: text_color,
//     ),
//   ),
//   // textTheme: GoogleFonts.ubuntuTextTheme(
//   //   Theme.of(Get.context).textTheme,
//   // ),
//   scaffoldBackgroundColor: grey_bg,
// );

///
const biconColorO = Colors.blueGrey;
final bdisabledColorLightO = Colors.grey[300];
const bdisabledColorDark = Colors.grey;
const bsubTitleTextColor = Colors.grey;

//////// ICONS ////////
IconButton customAddIcon({required VoidCallback onPressed, bool isEnabled = true}) {
  return IconButton(
    icon: const Icon(Icons.add_circle_rounded),
    visualDensity: VisualDensity.compact,
    onPressed: isEnabled ? onPressed : null,
    color: isEnabled ? biconColorO : bdisabledColorLightO,
  );
}

const backgroundWidgetBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(8),
    bottomRight: Radius.circular(8),
    bottomLeft: Radius.circular(8),
  ),
);
