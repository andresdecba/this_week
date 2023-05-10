import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';


Future<void> openBottomSheetWithScroll({
  required BuildContext context,
  required Widget widget,
  double maxChildSize = 0.95,
  double initialChildSize = 0.5,
  double minChildSize = 0.35,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    useSafeArea: true,

    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: initialChildSize,
        maxChildSize: maxChildSize,
        minChildSize: minChildSize,
        builder: (context, scrollController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // HANDLER
              SingleChildScrollView(
                controller: scrollController,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 5,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: disabledGrey,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ],
                ),
              ),
              // CONTENT
              Expanded(
                child: widget,
              ),
            ],
          );
        },
      );
    },
  );
}
