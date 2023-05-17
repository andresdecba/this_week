import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/open_task.dart/components/editable_text_form.dart';
import 'package:todoapp/ui/open_task.dart/components/options.dart';
import 'package:todoapp/ui/open_task.dart/components/small_button.dart';
import 'package:todoapp/ui/open_task.dart/components/save.dart';
import 'package:todoapp/ui/open_task.dart/components/text_form.dart';
import 'package:todoapp/ui/open_task.dart/view_task_controller.dart';

class ViewTask extends GetView<ViewTaskController> {
  const ViewTask({
    required this.task,
    Key? key,
  }) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          ///// formularios
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: controller.newFormKey,
                onWillPop: () async {
                  if (FocusScope.of(context).hasFocus) {
                    FocusScope.of(context).unfocus();
                    return false;
                  } else {
                    return true;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //// DESCRIPCION DE LA TAREA ////
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text('Descripción'),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                        child: MyEditableTextForm(
                          key: UniqueKey(),
                          texto: task.value.description,
                          onTap: () {},
                          textStyle: kTitleLarge,
                          returnText: (value) {
                            task.value.description = value;
                            task.value.save();
                          },
                        ),
                      ),

                      //// SUBTAREAS ////
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text('Subtareas'),
                      ),

                      //// CREAR NUEVA SUBTAREA ////
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: MyTextForm(
                          key: UniqueKey(),
                          returnText: (value) => controller.createSubtask(
                            task: task,
                            value: value,
                          ),
                        ),
                      ),

                      //// LISTA DE SUBTAREAS ////
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: AnimatedList(
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
                                        textStyle: e.isDone ? doneTxtStyle : kBodyMedium,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //// opciones
          const Divider(color: blackBg, height: 0),
          Options(task: task),

          //opciones del widget
          const Divider(color: disabledGrey, height: 0),
          Save(task: task),
          const SizedBox(height: 8),
        ],
      );
    });
  }
}

final doneTxtStyle = kTitleMedium.copyWith(
  decoration: TextDecoration.lineThrough,
  fontStyle: FontStyle.italic,
  color: disabledGrey,
);