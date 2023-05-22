import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';

class MyTextForm extends StatefulWidget {
  const MyTextForm({
    required this.returnText,
    Key? key,
  }) : super(key: key);

  final ReturnText returnText;

  @override
  State<MyTextForm> createState() => _MyTextFormState();
}

class _MyTextFormState extends State<MyTextForm> {
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
      style: kBodyMedium,
      decoration: myInputDecoration(
        hintText: 'Agregar nueva subtarea',
        clearText: () => _textEditingController.clear(),
      ),
      onTap: () {
        // no usar setState por que cierra el teclado
      },
      onChanged: (value) {
        // no usar setState por que cierra el teclado
      },
      // validator: (value) {
      //   // no usar setState por que cierra el teclado
      // },
      onEditingComplete: () {
        // usar setState cierra el teclado
        setState(() {
          widget.returnText(_textEditingController.text);
          _textEditingController.clear();
        });
      },
      onTapOutside: (event) {
        // no usar setState por que cierra el teclado
        _textEditingController.clear();
        if (_focusNode.hasFocus) _focusNode.unfocus();
      },
    );
  }
}

typedef ReturnText = void Function(String);

InputDecoration myInputDecoration({
  required String hintText,
  required VoidCallback clearText,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(8),
    isDense: true,
    border: const OutlineInputBorder(),
    alignLabelWithHint: true,
    hintText: hintText,
    hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
    counterText: "",
    suffixIconConstraints: const BoxConstraints(maxHeight: 100),
    suffixIcon: InkWell(
      onTap: () => clearText(),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Icon(Icons.close_rounded, size: 20),
      ),
    ),
    counterStyle: const TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 10,
      height: double.minPositive,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: disabledGrey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: bluePrimary),
    ),
  );
}

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

///// DECORATION STYLES   /////

