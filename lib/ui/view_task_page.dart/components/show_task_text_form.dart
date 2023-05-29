import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';

class ShowTaskTextForm extends StatefulWidget {
  const ShowTaskTextForm({
    required this.texto,
    required this.returnText,
    required this.textStyle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String texto;
  final ReturnText returnText;
  final TextStyle textStyle;
  final VoidCallback onTap;

  @override
  State<ShowTaskTextForm> createState() => _ShowTaskTextFormState();
}

class _ShowTaskTextFormState extends State<ShowTaskTextForm> {
  // CONTROLLERS
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textEditingController.text = widget.texto;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      focusNode: _focusNode,
      controller: _textEditingController,
      maxLines: null,
      maxLength: 200,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      style: widget.textStyle,
      decoration: myEditableInputDecoration(
        hintText: 'Escriba un valor', //'task description_description'.tr,
      ),
      onTap: () {
        // no usar setState por que cierra el teclado
        widget.onTap();
      },
      onChanged: (value) {
        // no usar setState por que cierra el teclado
      },
      // validator: (value) {
      //   // no usar setState por que cierra el teclado
      // },
      onEditingComplete: () {
        // no usar setState por que cierra el teclado
        _focusNode.unfocus();
        widget.returnText(_textEditingController.text);
      },
      onTapOutside: (event) {
        // no usar setState por que cierra el teclado
        if (_focusNode.hasFocus) _focusNode.unfocus();
      },
    );
  }
}

typedef ReturnText = void Function(String);

InputDecoration myEditableInputDecoration({
  required String hintText,
}) {
  return InputDecoration(
    contentPadding: EdgeInsets.zero,
    isDense: true,
    border: InputBorder.none,
    alignLabelWithHint: true,
    hintText: hintText,
    hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
    counterText: "",
  );
}
