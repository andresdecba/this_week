import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    this.title,
    this.description,
    required this.okCallBack,
    this.cancelCallBack,
    Key? key,
  }) : super(key: key);

  final String? title;
  final Widget? description;
  final VoidCallback okCallBack;
  final VoidCallback? cancelCallBack;
  //final BuildContext context;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      scrollable: true,
      title: title != null ? Text(title!) : null,
      content: description ?? Container(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      actions: <Widget>[

        // first button
        Visibility(
          visible: true,
          child: ElevatedButton(
            onPressed: () {
              okCallBack();
            },
            child: const Text("OK"),
          ),
        ),

        // second button
        Visibility(
          visible: true,
          child: ElevatedButton(
            child: const Text("Cancel"),
            onPressed: () {
              cancelCallBack == null ? Navigator.of(context).pop() : cancelCallBack!();
              //Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  
}
