import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  required String label,
  VoidCallback? clearText,
  String? hintText,
  Color? borderColor,
  bool? hasBorder = true,
}) {
  return InputDecoration(
    isDense: true,
    border: hasBorder == true ? const OutlineInputBorder() : InputBorder.none,
    label: Text(label),
    alignLabelWithHint: true,
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
    suffixIcon: hasBorder == true
        ? IconButton(
            icon: const Icon(Icons.clear), // clear text
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
        color: borderColor ?? Colors.blueAccent,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor ?? Colors.blueAccent,
      ),
    ),
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

final boxDecoration = BoxDecoration(
  color: Colors.grey[350],
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

const titleTextStyle = TextStyle(
  fontStyle: FontStyle.italic,
  color: Colors.blueGrey,
);

/////// COLORS //////
const iconColor = Colors.blueGrey;
final disabledColorLight = Colors.grey[300];
const disabledColorDark = Colors.grey;
const subTitleTextColor = Colors.grey;

//////// ICONS ////////
///
IconButton customAddIcon({required VoidCallback onPressed, bool isEnabled = true}) {
  return IconButton(
    icon: const Icon(Icons.add_circle_rounded),
    visualDensity: VisualDensity.compact,
    onPressed: isEnabled ? onPressed : null,
    color: isEnabled ? iconColor : disabledColorLight,
  );
}
