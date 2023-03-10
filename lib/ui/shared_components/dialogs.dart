import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';

////// GENERAL DIALOG //////
Future<T?> myCustomDialog<T>({
  required BuildContext context,
  required VoidCallback onPressOk,
  required String title,
  String? subtitle,
  String? okTextButton,
  String? cancelTextButton,
  String? iconPath,
  Color? iconColor,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.center,
        scrollable: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        //insetPadding: const EdgeInsets.all(5),
        //
        icon: Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            iconPath ?? 'assets/info.svg',
            alignment: Alignment.center,
            color: iconColor ?? blue_primary,
            height: 75,
          ),
        ),
        //iconPadding: const EdgeInsets.all(8),
        //
        title: Align(
          alignment: Alignment.center,
          child: Text(title),
        ),
        titleTextStyle: kTitleLarge,
        //titlePadding: const EdgeInsets.all(8),
        //
        content: subtitle != null
            ? Align(
                alignment: Alignment.center,
                child: Text(subtitle, textAlign: TextAlign.center),
              )
            : null,
        contentTextStyle: kTitleMedium,
        //contentPadding: const EdgeInsets.all(8),
        //
        actions: <Widget>[
          // cancel
          Visibility(
            visible: cancelTextButton == null ? false : true,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: blue_primary),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  withe_bg,
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 30),
                ),
              ),
              child: Text(
                cancelTextButton ?? 'Cancel',
                style: const TextStyle(color: blue_primary),
              ),
            ),
          ),
          // ok
          ElevatedButton(
            onPressed: () => onPressOk(),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 30),
              ),
            ),
            child: Text(okTextButton ?? 'Ok'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 25),
      );
    },
  );
}

////// CHANGE LANGUAGE //////
Future<T?> changeLangDialog<T>({
  required BuildContext context,
  required String title,
  required Widget elements,
}) {

  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        alignment: Alignment.center,
        scrollable: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        title: Align(
          alignment: Alignment.center,
          child: Text(title),
        ),
        titleTextStyle: kTitleLarge,
        content: elements,
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 25),
      );
    },
  );
}

////// CREATE SUBTASK //////
Future<T?> createSubtaskDialog<T>({
  required BuildContext context,
  required VoidCallback onPressOk,
  required String title,
  required Widget content,
  String? okTextButton,
  String? cancelTextButton,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // general
        alignment: Alignment.center,
        scrollable: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),

        // title
        title: Align(
          alignment: Alignment.center,
          child: Text(title),
        ),
        titleTextStyle: kTitleLarge,

        // form
        content: content,

        // buttons
        actions: <Widget>[
          // cancel
          Visibility(
            visible: cancelTextButton == null ? false : true,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: blue_primary),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  withe_bg,
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 30),
                ),
              ),
              child: Text(
                cancelTextButton ?? 'Cancel',
                style: const TextStyle(color: blue_primary),
              ),
            ),
          ),
          // ok
          ElevatedButton(
            onPressed: () {
              onPressOk();
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 30),
              ),
            ),
            child: Text(okTextButton ?? 'Ok'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 25),
      );
    },
  );
}
