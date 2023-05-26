import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';

void myModalBottomSheet({
  required BuildContext context,
  required Widget child,
  bool enableDrag = true,
  bool showClose = false,
  VoidCallback? onTapClose,
}) {
  showModalBottomSheet<dynamic>(
    isDismissible: true,
    showDragHandle: enableDrag,
    enableDrag: enableDrag,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    useSafeArea: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            children: [
              child, /////////// <- child
              Visibility(
                visible: showClose,
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                    onPressed: onTapClose != null ? () => onTapClose() : null,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: disabledGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

//() => Get.find<CreateTaskPageController>().closeAndRestoreValues(),