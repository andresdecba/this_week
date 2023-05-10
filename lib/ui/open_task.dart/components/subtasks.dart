import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/components/subtask_tile.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';


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
