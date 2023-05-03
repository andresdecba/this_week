import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';

Future<void> openBottomSheet({required BuildContext context, required Widget widget}) {
  return showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    context: context,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 5,
            width: 50,
            decoration: const BoxDecoration(
              color: disabled_grey,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          Expanded(
            child: widget,
          ),
        ],
      );
    },
  );
}
