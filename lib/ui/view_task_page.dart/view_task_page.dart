import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/models/subtask_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/view_task_page.dart/components/my_editable_text_form.dart';
import 'package:todoapp/ui/view_task_page.dart/components/expandible_options.dart';
import 'package:todoapp/ui/view_task_page.dart/components/notification_details.dart';
import 'package:todoapp/ui/view_task_page.dart/components/small_button.dart';
import 'package:todoapp/ui/view_task_page.dart/components/create_subtask_form.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';

class ViewTask2 extends GetView<ViewTaskController> {
  const ViewTask2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///// formularios
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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

                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Text('Subtareas'),
                        ),

                        //// CREAR NUEVA SUBTAREA ////
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: CreateSubtaskForm(),
                          //child: TextField(),
                        ),

                        //// LISTA DE SUBTAREAS ////
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: _SubtasksAnimatedList(),
                        ),
                      ],
                    ),
                  ),
                ),

                // notificaciones opt //
                const Divider(color: enabledGrey, height: 0),
                const NotificationDetails(),
                //const SizedBox(height: 8),
              ],
            ),
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

class _SubtasksAnimatedList extends GetView<ViewTaskController> {
  const _SubtasksAnimatedList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedList(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        initialItemCount: controller.task.value.subTasks.length,
        key: Globals.animatedListStateKey,
        itemBuilder: (context, index, animation) {
          SubTaskModel e = controller.task.value.subTasks[index];
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
    );
  }
}

final doneTxtStyle = kTitleMedium.copyWith(
  decoration: TextDecoration.lineThrough,
  fontStyle: FontStyle.italic,
  color: enabledGrey.withOpacity(0.5),
);
