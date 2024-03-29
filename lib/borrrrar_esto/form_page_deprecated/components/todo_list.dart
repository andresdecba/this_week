// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:todoapp/ui/commons/styles.dart';
// import 'package:todoapp/ui/form_page/forms_page_controller.dart';
// import 'package:todoapp/ui/shared_components/dialogs.dart';

// class TodoList extends GetView<FormsPageController> {
//   const TodoList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: [
//         // TITLE
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'todo list'.tr,
//               style: kTitleLarge,
//             ),
//             IconButton(
//               onPressed: () {
//                 FocusScope.of(context).unfocus(); // hide keyboard if open
//                 createSubtaskDialog(
//                   context: context,
//                   title: 'create subtask'.tr,
//                   content: _SubtaskForm(controller: controller),
//                   cancelTextButton: 'cancel'.tr,
//                   okTextButton: 'create'.tr,
//                   onPressOk: () => controller.createSubtask(),
//                 );
//               },
//               icon: const Icon(Icons.add_circle_rounded),
//             ),
//           ],
//         ),
//         const SizedBox(height: 30),
//         // CREATE LIST
//         Obx(
//           () => (controller.getTask.subTasks != null && controller.getTask.subTasks!.isEmpty)
//               // SHOW NO SUBTASKS
//               ? Container(
//                   key: UniqueKey(),
//                   height: 50,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.4),
//                     borderRadius: const BorderRadius.all(Radius.circular(5)),
//                   ),
//                   alignment: Alignment.centerLeft,
//                   padding: const EdgeInsets.all(16),
//                   child: Text(
//                     'here you can add a sub task list'.tr,
//                     style: kBodyMedium.copyWith(color: disabledGrey, fontStyle: FontStyle.italic),
//                   ),
//                 )
//               // SHOW TASKS
//               : Wrap(
//                   children: [
//                     const Divider(height: 0),
//                     _TodoList(controller: controller),
//                     const Divider(height: 0),
//                   ],
//                 ),
//         ),
//       ],
//     );
//   }
// }

// class _SubtaskForm extends StatelessWidget {
//   const _SubtaskForm({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   final FormsPageController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: TextFormField(
//         controller: controller.subTaskTitleCtrlr,
//         enabled: true,
//         maxLines: 4,
//         decoration: customInputDecoration(
//           label: 'Subtarea',
//           hintText: 'create subtask_description'.tr,
//           clearText: () => controller.subTaskTitleCtrlr.clear(),
//           isEnabled: true,
//           hasBorder: true,
//         ),
//         maxLength: 100,
//         keyboardType: TextInputType.text,
//         textCapitalization: TextCapitalization.sentences,
//         textInputAction: TextInputAction.done,
//         autofocus: true,
//       ),
//     );
//   }
// }

// class _TodoList extends StatefulWidget {
//   const _TodoList({
//     required this.controller,
//     Key? key,
//   }) : super(key: key);
//   final FormsPageController controller;
//   @override
//   State<_TodoList> createState() => _TodoListState();
// }

// class _TodoListState extends State<_TodoList> {
//   @override
//   Widget build(BuildContext context) {
//     return ReorderableListView(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       buildDefaultDragHandles: false,
//       onReorder: (int oldIndex, int newIndex) {
//         setState(() {
//           if (oldIndex < newIndex) {
//             newIndex -= 1;
//           }
//           widget.controller.reorderSubtasks(newIndex: newIndex, oldIndex: oldIndex);
//         });
//       },
//       children: widget.controller.getTask.subTasks!.map(
//         (e) {
//           int i = widget.controller.getTask.subTasks!.indexOf(e);
//           return Dismissible(
//             key: UniqueKey(),
//             onDismissed: (direction) {
//               if (direction == DismissDirection.startToEnd) {
//                 widget.controller.deleteSubtask(i);
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
//               trailing: ReorderableDragStartListener(
//                 index: i,
//                 child: const IconButton(
//                   icon: Icon(Icons.drag_handle),
//                   onPressed: null,
//                 ),
//               ),
//               onLongPress: () {
//                 widget.controller.subTaskTitleCtrlr.text = e.title;
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
//               leading: Checkbox(
//                 shape: const CircleBorder(),
//                 activeColor: statusTaskDone,
//                 value: widget.controller.getTask.subTasks![i].isDone,
//                 visualDensity: VisualDensity.compact,
//                 onChanged: (value) {
//                   widget.controller.updateStatusSubtask(i);
//                 },
//               ),
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
