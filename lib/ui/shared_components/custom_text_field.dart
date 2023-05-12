import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    this.hintText = 'hint_text',
    this.initialValue = 'initialValue',
    this.borderSideColor = bluePrimary,
    this.enableReadMode = false,
    this.textStyle,
    required this.getValue,
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final TextStyle? textStyle;
  final String initialValue;
  final bool enableReadMode;
  final Color borderSideColor;
  final MyFunction getValue;
  final FocusNode focusNode;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController taskDescriptionCtrlr = TextEditingController();

  bool readOnly = false;

  @override
  void initState() {
    if (widget.enableReadMode) {
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
        //widget.focusNode.unfocus();
        // FocusScope.of(context).unfocus();
        debugPrint('aver: custom_text_field');
        if (widget.enableReadMode) {
          setState(() {
            readOnly = false;
            widget.focusNode.requestFocus();
          });
        }
      },
      child: TextFormField(
        controller: taskDescriptionCtrlr,

        autofocus: true, //widget.enableReadMode ? readOnly : false,
        focusNode: widget.focusNode,
        readOnly: readOnly, //widget.enableReadOnly ? false : readOnly,

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
            if (widget.enableReadMode) {
              readOnly = true;
            }
            widget.getValue(taskDescriptionCtrlr.text);
            taskDescriptionCtrlr.clear();
            //widget.focusNode.unfocus();

            FocusScope.of(context).unfocus(); //remove focus
            //WidgetsBinding.instance.addPostFrameCallback((_) => _textEditingController.clear()); // clear content
          });
        },
        onTapOutside: (event) {
          debugPrint('aver: custom_text_field - onTapOutside');
          if (widget.enableReadMode) {
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
      contentPadding: isEnabledToEdit ? const EdgeInsets.fromLTRB(8, 8, 8, 8) : EdgeInsets.zero,
      isDense: true,
      border: isEnabledToEdit ? const OutlineInputBorder() : InputBorder.none,
      //labelStyle: const TextStyle(color: bluePrimary),
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