import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';

class CustomTextFieldBU extends StatefulWidget {
  const CustomTextFieldBU({
    this.hintText = 'hint_text',
    this.initialValue = 'initialValue',
    this.borderSideColor = bluePrimary,
    this.convertToText = false,
    this.textStyle,
    required this.getValue,
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final TextStyle? textStyle;
  final String initialValue;
  final bool convertToText;
  final Color borderSideColor;
  final MyFunction getValue;
  final FocusNode focusNode;

  @override
  State<CustomTextFieldBU> createState() => _CustomTextFieldBUState();
}

class _CustomTextFieldBUState extends State<CustomTextFieldBU> {
  final TextEditingController taskDescriptionCtrlr = TextEditingController();

  bool readOnly = false;

  @override
  void initState() {
    if (widget.convertToText) {
      taskDescriptionCtrlr.text = widget.initialValue;
      readOnly = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    taskDescriptionCtrlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        debugPrint('aver: custom_text_field');
        if (widget.convertToText) {
          setState(() {
            readOnly = false;
          });
        }
      },
      child: TextFormField(
        controller: taskDescriptionCtrlr,
        readOnly: widget.convertToText ? readOnly : false,
        autofocus: true,
        maxLines: null,
        maxLength: 200,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        style: widget.textStyle,
        decoration: _customInputDecoration(
          isEnabledToEdit: !readOnly, //widget.enableReadOnly ? true : !readOnly,
          label: 'task description'.tr,
          hintText: widget.hintText, //'task description_description'.tr,
          clearText: () => taskDescriptionCtrlr.clear(),
        ),
        validator: (value) {
          if (value != null && value.length < 7) {
            return 'task description error'.tr;
          } else {
            return null;
          }
        },
        onEditingComplete: () {
          setState(() {
            if (widget.convertToText) {
              readOnly = true;
            }
            if (!widget.convertToText) {
              taskDescriptionCtrlr.clear();
            }

            widget.getValue(taskDescriptionCtrlr.text);
            FocusScope.of(context).unfocus(); //remove focus
            //widget.focusNode.unfocus();
            //WidgetsBinding.instance.addPostFrameCallback((_) => _textEditingController.clear()); // clear content
          });
        },
        onTapOutside: (event) {
          debugPrint('aver: custom_text_field - onTapOutside');
          if (widget.convertToText) {
            setState(() => readOnly = true);
          }
        },
      ),
    );
  }

  // textfield style
  InputDecoration _customInputDecoration({
    required String label,
    required String hintText,
    required VoidCallback clearText,
    required bool isEnabledToEdit,
  }) {
    return InputDecoration(
      //labelStyle: const TextStyle(color: bluePrimary),
      contentPadding: isEnabledToEdit ? const EdgeInsets.fromLTRB(8, 8, 8, 8) : EdgeInsets.zero,
      isDense: true,
      border: isEnabledToEdit ? const OutlineInputBorder() : InputBorder.none,
      alignLabelWithHint: true,
      hintText: hintText,
      hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
      filled: isEnabledToEdit,
      fillColor: witheBg.withOpacity(0.4),
      counterText: "",
      suffixIconConstraints: const BoxConstraints(maxHeight: 100),
      suffixIcon: isEnabledToEdit
          ? InkWell(
              onTap: () => clearText(),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Icon(Icons.close_rounded, size: 20),
              ),
            )
          : null,
      counterStyle: const TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 10,
        height: double.minPositive,
      ),
      enabledBorder: isEnabledToEdit
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: disabledGrey),
            )
          : null,
      focusedBorder: isEnabledToEdit
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: bluePrimary),
            )
          : null,
    );
  }
}

typedef MyFunction = void Function(String);



  /*
  onWillPop: () async {
     onWillPop: () async {
        widget.focusNode.requestFocus();
        setState(() {
          if (widget.enableReadMode) {
            readOnly = true;
            widget.focusNode.unfocus();
            print('hola: 1 ${widget.enableReadMode}');
          }
          if (!widget.enableReadMode) {
            widget.focusNode.unfocus();
            print('hola: 2 ${widget.enableReadMode}');
          }
        });
        print('hola: ${widget.initialValue}');
        return false;
      },
  */