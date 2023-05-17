import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/open_task.dart/components/small_button.dart';
import 'package:todoapp/ui/open_task.dart/open_task_controller.dart';

class Nueva extends StatefulWidget {
  const Nueva({
    required this.task,
    Key? key,
  }) : super(key: key);

  final Rx<TaskModel> task;

  @override
  State<Nueva> createState() => _NuevaState();
}

class _NuevaState extends State<Nueva> {
  // lista animada de las subtareas
  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey();
  final Duration listDuration = const Duration(milliseconds: 500);
  final GlobalKey<FormState> newFormKey = GlobalKey<FormState>();
  final controller = Get.lazyPut(() => OpenTaskController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: newFormKey,
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
              texto: widget.task.value.description,
              seleccionado: true,
              returnText: (value) {
                widget.task.value.description = value;
                widget.task.value.save();
              },
            ),
          ),

          //// CREAR NUEVA SUBTAREA ////
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: MyTextForm(
              returnText: (value) {
                widget.task.value.subTasks.add(SubTaskModel(title: value, isDone: false));
                widget.task.value.save();
                widget.reactive.refresh();
              },
            ),
          ),

          //// LISTA DE SUBTAREAS ////
          AnimatedList(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            initialItemCount: widget.task.value.subTasks.length,
            key: animatedListKey,
            itemBuilder: (context, index, animation) {
              SubTaskModel e = widget.task.value.subTasks[index];
              bool cambiar = false;
              Widget child = Container();

              return FadeTransition(
                key: UniqueKey(),
                opacity: animation,
                child: SizeTransition(
                  key: UniqueKey(),
                  sizeFactor: animation,
                  child: Container(
                    decoration: BoxDecoration(
                      border: index + 1 == widget.task.value.subTasks.length ? null : const Border(bottom: BorderSide(width: 1.0, color: disabledGrey)),
                    ),
                    child: Row(
                      key: UniqueKey(),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // leading
                        SmallButton(
                          onTap: () {
                            setState(() {
                              e.isDone = !e.isDone;
                              widget.task.refresh();
                            });
                          },
                          icon: e.isDone ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
                          iconColor: e.isDone ? disabledGrey : null,
                        ),

                        // TEXT
                        Expanded(
                          child: MyEditableTextForm(
                            texto: e.title,
                            seleccionado: cambiar,
                            key: UniqueKey(),
                            returnText: (value) {
                              e.title = value;
                              widget.task.value.save();
                            },
                          ),
                        ),

                        // trailing
                        Visibility(
                          visible: e.isDone,
                          child: SmallButton(
                            icon: Icons.close_rounded,
                            iconColor: disabledGrey,
                            onTap: () {
                              setState(() {
                                // controller.removeSubtask(
                                //   index: index,
                                //   task: widget.task.value,
                                //   child: child,
                                // );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyEditableTextForm extends StatefulWidget {
  const MyEditableTextForm({
    required this.texto,
    required this.seleccionado,
    required this.returnText,
    Key? key,
  }) : super(key: key);

  final String texto;
  final bool seleccionado;
  final ReturnText returnText;

  @override
  State<MyEditableTextForm> createState() => _MyEditableTextFormState();
}

class _MyEditableTextFormState extends State<MyEditableTextForm> {
  // CONTROLLERS
  final TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    debugPrint('aver: "DISPOSED" $focusNode');
    super.dispose();
  }

  @override
  void initState() {
    textEditingController.text = widget.texto;
    debugPrint('aver: "INITIALIZED" $focusNode');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      focusNode: focusNode,
      controller: textEditingController,
      maxLines: null,
      maxLength: 200,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      style: focusNode.hasFocus
          ? kBodyMedium.copyWith(
              color: blackBg,
              backgroundColor: bluePrimary.withOpacity(0.15),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.normal,
            )
          : kBodyMedium,
      decoration: _customInputDecoration(
        isUpdateStyle: widget.seleccionado, //
        label: 'task description'.tr,
        hintText: 'hintText', //'task description_description'.tr,
        clearText: () => textEditingController.clear(),
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
        // no usar setState por que cierra el teclado
        focusNode.unfocus();
        widget.returnText(textEditingController.text);
      },
      onTapOutside: (event) {
        // no usar setState por que cierra el teclado
        if (focusNode.hasFocus) focusNode.unfocus();
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
  final TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      focusNode: focusNode,
      controller: textEditingController,
      maxLines: null,
      maxLength: 200,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      style: focusNode.hasFocus
          ? kBodyMedium.copyWith(
              color: blackBg,
              backgroundColor: bluePrimary.withOpacity(0.15),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.normal,
            )
          : kBodyMedium,
      decoration: _customInputDecoration(
        isUpdateStyle: true, //
        label: 'task description'.tr,
        hintText: 'hintText', //'task description_description'.tr,
        clearText: () => textEditingController.clear(),
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
        // no usar setState por que cierra el teclado
        focusNode.unfocus();
        widget.returnText(textEditingController.text);
      },
      onTapOutside: (event) {
        // no usar setState por que cierra el teclado
        if (focusNode.hasFocus) focusNode.unfocus();
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

InputDecoration _customInputDecoration({
  required String label,
  required String hintText,
  required VoidCallback clearText,
  required bool isUpdateStyle,
}) {
  return InputDecoration(
    //labelStyle: const TextStyle(color: bluePrimary),
    //filled: true,
    contentPadding: EdgeInsets.zero, // readOnly ? const EdgeInsets.fromLTRB(8, 8, 8, 8) : EdgeInsets.zero,
    isDense: true,
    border: InputBorder.none, // readOnly ? const OutlineInputBorder() : InputBorder.none,
    alignLabelWithHint: true,
    hintText: hintText,
    hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
    fillColor: witheBg.withOpacity(0.4),
    counterText: "",
    suffixIconConstraints: const BoxConstraints(maxHeight: 100),
    counterStyle: const TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 10,
      height: double.minPositive,
    ),
  );
}


/*
TextFormField(
                        key: UniqueKey(),
                        //focusNode: focusNode,
                        controller: textEditingController,
                        maxLines: null,
                        maxLength: 200,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        style: focusNode.hasFocus
                            ? kBodyMedium.copyWith(
                                color: blackBg,
                                backgroundColor: bluePrimary.withOpacity(0.15),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.normal,
                              )
                            : kBodyMedium,
                        decoration: _customInputDecoration(
                          isUpdateStyle: cambiar, //
                          label: 'task description'.tr,
                          hintText: 'hintText', //'task description_description'.tr,
                          clearText: () => textEditingController.clear(),
                        ),
                        onTap: () {
                          setState(() {
                            debugPrint('aver: subtask $index onTap: ${focusNode.hasPrimaryFocus}');
                            cambiar = true;
                          });
                        },
                        onChanged: (value) {
                          debugPrint('aver: subtask $index onChanged: ${focusNode.hasPrimaryFocus}');
                        },
                        validator: (value) {},
                        onEditingComplete: () {
                          cambiar = false;
                          //FocusScope.of(context).unfocus();
                        },
                        onTapOutside: (event) {
                          cambiar = false;
                          debugPrint('aver: subtask $index outside: ${focusNode.hasPrimaryFocus}');
                          if (focusNode.hasFocus) {
                            focusNode.unfocus();
                          }
                          //FocusScope.of(context).unfocus();
                        },
                      ),
*/