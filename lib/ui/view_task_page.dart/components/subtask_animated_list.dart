import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/models/subtask_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/view_task_page.dart/components/my_editable_text_form.dart';
import 'package:todoapp/ui/view_task_page.dart/components/small_button.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';

class SubtasksAnimatedList extends GetView<ViewTaskController> {
  const SubtasksAnimatedList({super.key});

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
