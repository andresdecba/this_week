import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';

/*
**** HOW TO USE ****
CustomTextField(
  textValue: 'Holalalalala',
  myFunction: (value) {
    // devuelve el txt ingresado
    task.value.description = value;
    task.refresh();
  },
),
*/

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    //required this.task,
    required this.myFunction,
    required this.textValue,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  //final Rx<TaskModel> task;
  final String textValue;
  final MyFunction myFunction;
  final TextStyle? textStyle;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController taskDescriptionCtrlr = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  bool isReadOnly = true;

  @override
  void initState() {
    taskDescriptionCtrlr.text = widget.textValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isReadOnly = true;
        });
        return true;
      },
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            isReadOnly = false;
            focusNode1.requestFocus();
          });
        },
        child: TextFormField(
          controller: taskDescriptionCtrlr,
          autofocus: !isReadOnly,
          focusNode: focusNode1,
          readOnly: isReadOnly,
          decoration: _customInputDecoration(
            isEnabled: !isReadOnly,
            label: 'task description'.tr,
            hintText: 'task description_description'.tr,
            clearText: () => taskDescriptionCtrlr.clear(),
          ),
          maxLines: null,
          maxLength: 200,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          style: widget.textStyle,
          validator: (value) {
            if (value != null && value.length < 7) {
              return 'task description error'.tr;
            } else {
              return null;
            }
          },
          onEditingComplete: () {
            setState(() {
              isReadOnly = true;
              widget.myFunction(taskDescriptionCtrlr.text);
            });
          },
          onTapOutside: (event) {
            setState(() {
              isReadOnly = true;
            });
          },
        ),
      ),
    );
  }

  // textfield style
  InputDecoration _customInputDecoration({
    required String label,
    required String hintText,
    required VoidCallback clearText,
    required bool isEnabled,
  }) {
    return InputDecoration(
      contentPadding: isEnabled ? const EdgeInsets.all(10) : EdgeInsets.zero,
      isDense: true,
      border: isEnabled == true ? const OutlineInputBorder() : InputBorder.none,
      labelStyle: const TextStyle(color: bluePrimary),
      alignLabelWithHint: true,
      hintText: hintText,
      hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
      filled: isEnabled,
      fillColor: witheBg.withOpacity(0.4),
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
}

typedef MyFunction = void Function(String);
