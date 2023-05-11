import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/components/small_button.dart';
import 'package:todoapp/ui/open_task.dart/components/subtitle_item_tile.dart';
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
                      textValue: e.title,
                      textStyle: e.isDone ? doneTxtStyle : kTitleMedium,
                      myFunction: (value) {
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
                        task.value.subTasks.removeAt(index);
                        task.refresh();
                        controller.removeSubtask(
                          index: index,
                          child: Container(height: 30, width: double.infinity, color: yellowPrimary),
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

      Wrap(
        children: [
          ...task.value.subTasks.map((e) {
            return Row(
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
                    textValue: e.title,
                    textStyle: e.isDone ? doneTxtStyle : kTitleMedium,
                    myFunction: (value) {
                      e.title = value;
                      task.refresh();
                    },
                  ),
                ),
                // trailing
                Visibility(
                  visible: e.isDone,
                  child: SmallButton(
                    onTap: () {
                      task.value.subTasks.remove(e);
                      task.refresh();
                    },
                    icon: Icons.close_rounded,
                    iconColor: disabledGrey,
                  ),
                ),
              ],
            );
            //
          }),
        ],
      );
    });
  }
}



// class Subtasks extends GetView<InitialPageController> {
//   const Subtasks({
//     required this.task,
//     Key? key,
//   }) : super(key: key);

//   final Rx<TaskModel> task;

//   @override
//   Widget build(BuildContext context) {
//     return ReorderableListView(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       buildDefaultDragHandles: false,
//       onReorder: (int oldIndex, int newIndex) {
//         // setState(() {
//         //   if (oldIndex < newIndex) {
//         //     newIndex -= 1;
//         //   }
//         //   widget.controller.reorderSubtasks(newIndex: newIndex, oldIndex: oldIndex);
//         // });
//       },
//       children: task.value.subTasks.map(
//         (e) {
//           int i = task.value.subTasks.indexOf(e);
//           return Dismissible(
//             key: UniqueKey(),
//             onDismissed: (direction) {
//               if (direction == DismissDirection.startToEnd) {
//                 controller.deleteSubtask(i);
//               }
//             },
//             direction: DismissDirection.startToEnd,
//             background: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               alignment: Alignment.centerLeft,
//               color: warning,
//               child: const Icon(
//                 Icons.delete_forever_rounded,
//                 color: witheBg,
//               ),
//             ),

//             //// CARD SUBTASK ////
//             child: ListTile(
//               key: ValueKey(i),
//               contentPadding: const EdgeInsets.symmetric(vertical: 8),
//               dense: true,
//               visualDensity: VisualDensity.compact,

//               ////
//               trailing: ReorderableDragStartListener(
//                 index: i,
//                 child: const IconButton(
//                   icon: Icon(Icons.drag_handle),
//                   onPressed: null,
//                 ),
//               ),

//               ///
//               onLongPress: () {
//                 controller.subTaskTitleCtrlr.text = e.title;
//                 FocusScope.of(context).unfocus(); // hide keyboard if open
//                 createSubtaskDialog(
//                   context: context,
//                   title: 'update subtask'.tr,
//                   content: _SubtaskForm(controller: widget.controller),
//                   cancelTextButton: 'cancel'.tr,
//                   okTextButton: 'update'.tr,
//                   onPressOk: () => widget.controller.updateTextSubtask(i),
//                 );
//               },

//               //////
//               leading: Checkbox(
//                 shape: const CircleBorder(),
//                 activeColor: statusTaskDone,
//                 value: controller.getTask.subTasks[i].isDone,
//                 visualDensity: VisualDensity.compact,
//                 onChanged: (value) {
//                   controller.updateStatusSubtask(i);
//                 },
//               ),

//               /////
//               title: Text(
//                 e.title,
//                 style: e.isDone
//                     ? kBodyMedium.copyWith(
//                         decoration: TextDecoration.lineThrough,
//                         fontStyle: FontStyle.italic,
//                         color: disabledGrey,
//                       )
//                     : kBodyMedium.copyWith(
//                         color: enabledGrey,
//                       ),
//               ),
//             ),
//           );
//         },
//       ).toList(),
//     );
//   }
// }

/*
class Subtasks extends GetView<InitialPageController> {
  const Subtasks({required this.task, Key? key}) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...task.value.subTasks.map((e) {
          return SubtaskTile(
            title: e.title,
            icon: e.isDone ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
            onTap: () {},
          );
        }),
      ],
    );
  }
}
*/
