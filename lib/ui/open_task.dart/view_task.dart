import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/subtask_model.dart';
//import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/open_task.dart/components/editable_text_form.dart';
import 'package:todoapp/ui/open_task.dart/components/expandible_options.dart';
import 'package:todoapp/ui/open_task.dart/components/notification_details.dart';
import 'package:todoapp/ui/open_task.dart/components/small_button.dart';

import 'package:todoapp/ui/open_task.dart/components/text_form.dart';
import 'package:todoapp/ui/open_task.dart/view_task_controller.dart';

class ViewTask extends GetView<ViewTaskController> {
  const ViewTask({
    //required this.task,
    Key? key,
  }) : super(key: key);

  //final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Column(
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
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
                            child: MyEditableTextForm(
                              key: UniqueKey(),
                              texto: controller.task.value.description,
                              onTap: () {},
                              textStyle: kTitleLarge,
                              returnText: (value) => controller.saveDescriptionUpdate(value),
                            ),
                          ),

                          //// SUBTAREAS ////
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Text('Subtareas'),
                          ),

                          //// CREAR NUEVA SUBTAREA ////
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: MyTextForm(
                              key: UniqueKey(),
                              hintText: 'Agregar subtarea',
                              returnText: (value) => controller.createSubtask(value),
                            ),
                          ),

                          //// LISTA DE SUBTAREAS ////
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: AnimatedList(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              initialItemCount: controller.task.value.subTasks.length,
                              key: controller.animatedListKey,
                              itemBuilder: (context, index, animation) {
                                SubTaskModel e = controller.task.value.subTasks[index];

                                // Widget removeChild = Container(
                                //   width: double.infinity,
                                //   height: 50,
                                //   color: Colors.yellow,
                                // );

                                Widget removeChild = Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    key: UniqueKey(),
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // marcar subtarea //
                                      SmallButton(
                                        onTap: () {},
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
                                          returnText: (value) {},
                                        ),
                                      ),

                                      // eliminar subtarea //
                                      Visibility(
                                        visible: e.isDone,
                                        child: SmallButton(
                                          icon: Icons.close_rounded,
                                          iconColor: disabledGrey,
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                return FadeTransition(
                                  key: UniqueKey(),
                                  opacity: animation,
                                  child: SizeTransition(
                                    key: UniqueKey(),
                                    sizeFactor: animation,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        key: UniqueKey(),
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // marcar subtarea //
                                          SmallButton(
                                            onTap: () => controller.updateStatusSubtask(e),
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
                                              returnText: (value) => controller.updateTitleSubtask(e, value),
                                            ),
                                          ),

                                          // eliminar subtarea //
                                          Visibility(
                                            visible: e.isDone,
                                            child: SmallButton(
                                              icon: Icons.close_rounded,
                                              iconColor: disabledGrey,
                                              onTap: () => controller.removeSubtask(index: index, task: controller.task, child: removeChild),
                                            ),
                                          ),
                                        ],
                                      ),
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

              // notificaciones opt //
              const Divider(color: enabledGrey, height: 0),
              const NotificationDetails(),
              //const SizedBox(height: 8),
            ],
          ),

          ///// options /////
          Align(
            alignment: Alignment.topRight,
            child: ExpandibleOptions(
              task: controller.task,
            ),
          ),
        ],
      );
    });
  }
}

final doneTxtStyle = kTitleMedium.copyWith(
  decoration: TextDecoration.lineThrough,
  fontStyle: FontStyle.italic,
  color: enabledGrey.withOpacity(0.5),
);
