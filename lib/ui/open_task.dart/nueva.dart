import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/open_task.dart/components/small_button.dart';
import 'package:todoapp/ui/open_task.dart/nueva_controller.dart';

class NuevaWithGetView extends GetView<NuevaController> {
  const NuevaWithGetView({
    required this.task,
    Key? key,
  }) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Form(
        key: controller.newFormKey,
        onWillPop: () async {
          if (FocusScope.of(context).hasFocus) {
            FocusScope.of(context).unfocus();
            return false;
          } else {
            return true;
          }
        },
        child: Column(
          children: [
            
            //// DESCRIPCION DE LA TAREA ////
            Padding(
              padding: const EdgeInsets.all(20),
              child: MyEditableTextForm(
                key: UniqueKey(),
                texto: task.value.description,
                onTap: () {},
                textStyle: kTitleLarge.copyWith(color: bluePrimary),
                returnText: (value) {
                  task.value.description = value;
                  task.value.save();
                },
              ),
            ),

            //// CREAR NUEVA SUBTAREA ////
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MyTextForm(
                key: UniqueKey(),
                returnText: (value) => controller.createSubtask(
                  task: task,
                  value: value,
                ),
              ),
            ),

            //// LISTA DE SUBTAREAS ////
            AnimatedList(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              initialItemCount: task.value.subTasks.length,
              key: controller.animatedListKey,
              itemBuilder: (context, index, animation) {
                SubTaskModel e = task.value.subTasks[index];

                Widget removeChild = Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.yellow,
                );

                return FadeTransition(
                  key: UniqueKey(),
                  opacity: animation,
                  child: SizeTransition(
                    key: UniqueKey(),
                    sizeFactor: animation,
                    child: Row(
                      key: UniqueKey(),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // marcar subtarea //
                        SmallButton(
                          onTap: () {
                            e.isDone = !e.isDone;
                            task.refresh();
                          },
                          icon: e.isDone ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
                          iconColor: e.isDone ? disabledGrey : null,
                        ),

                        // descripcion de la subtarea //
                        Expanded(
                          child: MyEditableTextForm(
                            key: UniqueKey(),
                            texto: e.title,
                            onTap: () {},
                            textStyle: kBodyMedium.copyWith(
                              color: blackBg,
                              backgroundColor: bluePrimary.withOpacity(0.15),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal,
                            ),
                            returnText: (value) {
                              e.title = value;
                              task.value.save();
                            },
                          ),
                        ),

                        // eliminar subtarea //
                        Visibility(
                          visible: e.isDone,
                          child: SmallButton(
                            icon: Icons.close_rounded,
                            iconColor: disabledGrey,
                            onTap: () => controller.removeSubtask(
                              index: index,
                              task: task,
                              child: removeChild,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

class MyEditableTextForm extends StatefulWidget {
  const MyEditableTextForm({
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
  State<MyEditableTextForm> createState() => _MyEditableTextFormState();
}

class _MyEditableTextFormState extends State<MyEditableTextForm> {
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
      validator: (value) {
        // no usar setState por que cierra el teclado
      },
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
      validator: (value) {
        // no usar setState por que cierra el teclado
      },
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

///// DECORATION STYLES   /////

final doneTxtStyle = kTitleMedium.copyWith(
  decoration: TextDecoration.lineThrough,
  fontStyle: FontStyle.italic,
  color: disabledGrey,
);

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
