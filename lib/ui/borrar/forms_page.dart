// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:todoapp/models/task_model.dart';
// import 'package:todoapp/ui/commons/styles.dart';
// import 'package:todoapp/ui/form_page/forms_page_controller.dart';
// import 'package:todoapp/ui/shared_components/alert_dialog.dart';
// import 'package:todoapp/ui/shared_components/borrar/background_widget.dart';
// import 'package:todoapp/ui/shared_components/borrar/subtask_item.dart';
// import 'package:todoapp/ui/shared_components/borrar/toggle_status_btn.dart';
// import 'package:todoapp/utils/utils.dart';

// class FormsPage extends GetView<FormsPageController> {
//   const FormsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => controller.onWillPop(context),
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () => controller.onWillPop(context),
//             icon: const Icon(Icons.arrow_back),
//           ),
//           title: Text(
//             controller.isViewTask ? 'Ver tarea' : 'Crear nueva tarea',
//           ),
//           centerTitle: true,
//           titleTextStyle: const TextStyle(fontSize: 16),
//           actions: [
//             Obx(
//               () {
//                 return controller.isViewTask
//                     ? IconButton(
//                         onPressed: () => controller.isUpdateTask.value = !controller.isUpdateTask.value,
//                         icon: const Icon(Icons.edit),
//                         color: !controller.isUpdateTask.value ? Colors.white.withOpacity(0.5) : Colors.white,
//                       )
//                     : IconButton(
//                         onPressed: () => () => controller.saveAndNavigate(),
//                         icon: const Icon(Icons.done_rounded),
//                         color: !controller.isUpdateTask.value ? Colors.white.withOpacity(0.5) : Colors.white,
//                       );
//               },
//             ),
//           ],
//         ),

//         //
//         bottomNavigationBar: Obx(
//           () {
//             return controller.isUpdateTask.value
//                 ? Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size.fromHeight(40),
//                       ),
//                       onPressed: () => controller.saveAndNavigate(), //controller.enableAddTaskButton.value ? () => controller.saveAndNavigate() : null,
//                       child: const Text(
//                         'Add task',
//                       ),
//                     ),
//                   )
//                 : const SizedBox();
//           },
//         ),
//         body: SafeArea(
//           child: Obx(
//             () => SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   // PASO 1: SELECCIONAR DIA
//                   BackgroundWidget(
//                     child: Obx(() {
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             '1 - Crear tarea para el día:',
//                             style: titleTextStyle,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(Utils.parseDateToString(controller.getTaskDatetime)),
//                               IconButton(
//                                 icon: const Icon(Icons.edit_calendar),
//                                 visualDensity: VisualDensity.compact,
//                                 color: controller.isUpdateTask.value ? biconColorO : bdisabledColorLightO,
//                                 onPressed: () async {
//                                   // show the dialog
//                                   var tmpData = controller.getTaskDatetime;
//                                   await showDialog(
//                                     context: context,
//                                     builder: (BuildContext ctx) {
//                                       return CustomDialog(
//                                         title: 'Cambiar fecha',
//                                         content: SizedBox(
//                                           height: 300,
//                                           width: 200,
//                                           child: CalendarDatePicker(
//                                             initialDate: controller.getTaskDatetime,
//                                             firstDate: DateTime.now(),
//                                             lastDate: DateTime.now().add(const Duration(days: 365)),
//                                             onDateChanged: (date) {
//                                               tmpData = date;
//                                             },
//                                           ),
//                                         ),
//                                         okCallBack: () => controller.setTaskDatetime = tmpData,
//                                       );
//                                     },
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               TextButton(
//                                 onPressed: !controller.enableLocalNotifications.value
//                                     ? null
//                                     : () async {
//                                         // show the dialog
//                                         TimeOfDay? newTime = await showTimePicker(
//                                           context: context,
//                                           initialTime: controller.getNotificationTime,
//                                           initialEntryMode: TimePickerEntryMode.input,
//                                         );
//                                         if (newTime == null) {
//                                           return;
//                                         } else {
//                                           controller.setNotificationTime = newTime;
//                                           //controller.changeDateTime(newTime);
//                                         }
//                                       },
//                                 child: Text('Notificarme: ${controller.getNotificationTime.hour}:${controller.getNotificationTime.minute}'),
//                               ),
//                               Switch(
//                                 onChanged: (value) => controller.enableLocalNotifications.value = value,
//                                 value: controller.enableLocalNotifications.value,
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     }),
//                   ),

//                   // PASO 2: PONER TITLE + DESCRIPTION
//                   BackgroundWidget(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: const [
//                             Text(
//                               '2 - Ingresa un título y una descripción',
//                               style: titleTextStyle,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         const TitleAndDescriptionForms(),
//                       ],
//                     ),
//                   ),

//                   // PASO 3: AGREGAR UN STATUS
//                   BackgroundWidget(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           '3 - Opcional: definir un status inical',
//                           style: titleTextStyle,
//                         ),
//                         Center(
//                           child: ToggleStatusButton(
//                             task: controller.getTask,
//                             onChanged: () {},
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // PASO 4: AGREGAR SUBTAREAS
//                   BackgroundWidget(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               '4 - Opcional: agregar subtareas',
//                               style: titleTextStyle,
//                             ),
//                             customAddIcon(
//                               isEnabled: controller.isUpdateTask.value,
//                               onPressed: () => showSubtaskDialog(
//                                 context,
//                                 () => controller.createOrUpdateSubTask(),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         const SubTasksListView(),
//                         //const SizedBox(height: 30),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // textfields de titulo y descripcion
// class TitleAndDescriptionForms extends GetView<FormsPageController> {
//   const TitleAndDescriptionForms({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () {
//         return Form(
//           key: controller.formKey,
//           child: Column(
//             children: [
//               // titulo
//               // TextFormField(
//               //   enabled: controller.isEditionEnabled.value,
//               //   controller: controller.taskTitleCtrlr,
//               //   decoration: customInputDecoration(
//               //     hasBorder: controller.isEditionEnabled.value,
//               //     label: 'Título*',
//               //     hintText: 'Ingrese un título para la tarea',
//               //     borderColor: Colors.orange,
//               //     clearText: () => controller.taskTitleCtrlr.clear(),
//               //   ),
//               //   maxLines: 4,
//               //   maxLength: 140,
//               //   keyboardType: TextInputType.text,
//               //   textInputAction: TextInputAction.next,
//               //   onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
//               //   validator: (value) => value!.isEmpty ? 'Password cannot be blank' : null,
//               //   onTap: () => controller.formKey.currentState!.reset(),
//               // ),
//               // descripcion
//               const SizedBox(height: 10),
//               TextFormField(
//                 enabled: controller.isUpdateTask.value,
//                 controller: controller.taskDescriptionCtrlr,
//                 decoration: customInputDecoration(
//                   hasBorder: controller.isUpdateTask.value,
//                   label: 'Descripción',
//                   hintText: 'Opcional: Ingrese un descripción',
//                   clearText: () => controller.taskDescriptionCtrlr.clear(),
//                   isEnabled: controller.isUpdateTask.value,
//                 ),
//                 maxLines: 4,
//                 maxLength: 200,
//                 keyboardType: TextInputType.multiline,
//                 textInputAction: TextInputAction.done,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// /// lista de subtareas agregadas
// class SubTasksListView extends GetView<FormsPageController> {
//   const SubTasksListView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => controller.getSubTaskList.value.isEmpty
//           ? const Center(child: Text('No hay subtasks'))
//           : ReorderableListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: controller.getSubTaskList.value.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return SubTaskItem(
//                   controller: controller,
//                   index: index,
//                   key: Key('$index'),
//                   isEnabled: controller.isUpdateTask.value,
//                 );
//               },
//               onReorder: (int oldIndex, int newIndex) {
//                 if (oldIndex < newIndex) {
//                   newIndex -= 1;
//                 }
//                 final SubTask item = controller.getSubTaskList.value.removeAt(oldIndex);
//                 controller.getSubTaskList.value.insert(newIndex, item);
//               },
//             ),
//     );
//   }
// }

// // crear subtarea modal
// Future<dynamic> showSubtaskDialog(BuildContext context, VoidCallback callBack) {
//   return showDialog(
//     context: context,
//     builder: (_) {
//       return CustomDialog(
//         content: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: const <Widget>[
//               Text('Agregar una subtarea'),
//               SizedBox(height: 30),
//               SubTaskForms(),
//             ],
//           ),
//         ),
//         okCallBack: callBack,
//       );
//     },
//   );
// }

// // textfield de la subtarea
// class SubTaskForms extends GetView<FormsPageController> {
//   const SubTaskForms({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: Column(
//         children: [
//           TextFormField(
//             controller: controller.subTaskTitleCtrlr,
//             enabled: true,
//             maxLines: 4,
//             decoration: customInputDecoration(
//               label: 'Subtarea',
//               hintText: 'Ingresar descripcion de la subtarea',
//               clearText: () => controller.subTaskTitleCtrlr.clear(),
//               isEnabled: true,
//               hasBorder: true,
//             ),
//             maxLength: 100,
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.done,
//             autofocus: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
