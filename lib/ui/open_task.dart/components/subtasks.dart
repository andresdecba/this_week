import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/components/small_button.dart';
import 'package:todoapp/ui/shared_components/custom_text_field.dart';

class Subtasks extends GetView<InitialPageController> {
  const Subtasks({required this.task, Key? key}) : super(key: key);
  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    final doneTxtStyle = kTitleMedium.copyWith(
      decoration: TextDecoration.lineThrough,
      fontStyle: FontStyle.italic,
      color: disabledGrey,
    );

    return Obx(() {
      return AnimatedList(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        initialItemCount: task.value.subTasks.length,
        key: controller.animatedListKey,
        itemBuilder: (context, index, animation) {
          //
          SubTaskModel e = task.value.subTasks[index];

          Widget child = Row(
            key: UniqueKey(),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // leading
              SmallButton(
                onTap: () {},
                icon: e.isDone ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
                iconColor: e.isDone ? disabledGrey : null,
              ),
              // descripcion
              Flexible(
                child: CustomTextField(
                  focusNode: controller.focusNode,
                  initialValue: e.title,
                  textStyle: e.isDone ? doneTxtStyle : kTitleMedium,
                  getValue: (value) {},
                ),
              ),
              // trailing
              Visibility(
                visible: e.isDone,
                child: SmallButton(
                  icon: Icons.close_rounded,
                  iconColor: disabledGrey,
                  onTap: () {},
                ),
              ),
            ],
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
                  // leading
                  SmallButton(
                    onTap: () {
                      e.isDone = !e.isDone;
                      task.refresh();
                    },
                    icon: e.isDone ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
                    iconColor: e.isDone ? disabledGrey : null,
                  ),
                  // descripcion
                  Flexible(
                    child: CustomTextField(
                      key: UniqueKey(),
                      focusNode: controller.focusNode,
                      enableReadMode: true,
                      initialValue: e.title,
                      textStyle: e.isDone ? doneTxtStyle : kTitleMedium,
                      getValue: (value) {
                        e.title = value;
                        task.refresh();
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
                        controller.removeSubtask(
                          index: index,
                          task: task.value,
                          child: child,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
