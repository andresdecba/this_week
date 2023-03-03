// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:todoapp/ui/commons/styles.dart';
// import 'package:todoapp/ui/form_page/forms_page_controller.dart';
// import 'package:todoapp/ui/borrar/forms_page.dart';

// class SubTaskItem extends StatelessWidget {
//   const SubTaskItem({
//     required this.index,
//     required this.controller,
//     required this.isEnabled,
//     Key? key,
//   }) : super(key: key);

//   final int index;
//   final FormsPageController controller;
//   final bool isEnabled;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Container(
//         key: Key('$index'),
//         constraints: const BoxConstraints(minWidth: 100, maxWidth: 100),
//         alignment: Alignment.centerLeft,
//         padding: const EdgeInsets.all(12),
//         margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//         decoration: boxDecoration,
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     controller.getSubTaskList.value[index].title,
//                   ),
//                 ),
//               ],
//             ),

//             /// options
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 //move
//                 ReorderableDragStartListener(
//                   key: Key('$index'),
//                   index: index,
//                   child: const Icon(
//                     Icons.drag_handle,
//                     color: Colors.blueAccent,
//                   ),
//                 ),

//                 //done, edit, delete
//                 Wrap(
//                   children: [
//                     IconButton(
//                       onPressed: () {},
//                       visualDensity: VisualDensity.compact,
//                       icon: const Icon(Icons.check_circle_outline),
//                       color: Colors.green[600],
//                     ),

//                     // editar subtask
//                     IconButton(
//                       onPressed: controller.isUpdateTask.value
//                           ? () {
//                               controller.fillSubTaskTFWhenUpdate(index);
//                               showSubtaskDialog(context, () {});
//                             }
//                           : null,
//                       visualDensity: VisualDensity.compact,
//                       icon: const Icon(Icons.edit),
//                       color: controller.isUpdateTask.value ? biconColorO : bdisabledColorLightO,
//                     ),

//                     // eliminar subtask
//                     IconButton(
//                       onPressed: controller.isUpdateTask.value ? () => controller.deleteSubtask(index) : null,
//                       visualDensity: VisualDensity.compact,
//                       icon: const Icon(Icons.delete_forever),
//                       color: controller.isUpdateTask.value ? biconColorO : bdisabledColorLightO,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
