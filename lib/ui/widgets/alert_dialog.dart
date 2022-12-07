import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    this.title,
    required this.content,
    required this.okCallBack,
    this.cancelCallBack,
    this.isNavigable = false,
    Key? key,
  }) : super(key: key);

  final String? title;
  final Widget content;
  final VoidCallback okCallBack;
  final VoidCallback? cancelCallBack;
  final bool? isNavigable;
  //final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      scrollable: true,
      title: title != null ? Text(title!) : null,
      content: content,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            okCallBack();
            if (isNavigable == false) {
              Navigator.of(context).pop();
            }
          },
          child: const Text("OK"),
        ),
        ElevatedButton(
          child: const Text("Cancel"),
          onPressed: () {
            cancelCallBack == null ? Navigator.of(context).pop() : cancelCallBack!();
            //Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
