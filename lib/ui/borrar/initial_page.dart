// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:todoapp/models/task_model.dart';
// import 'package:todoapp/services/local_notifications_service.dart';
// import 'package:todoapp/ui/commons/styles.dart';
// import 'package:todoapp/ui/controllers/initial_page_controller.dart';
// import 'package:todoapp/ui/widgets/alert_dialog.dart';
// import 'package:todoapp/ui/widgets/side_bar.dart';
// import 'package:todoapp/ui/widgets/task_card.dart';
// import 'package:todoapp/ui/widgets/task_card_widget.dart';
// import 'package:intl/intl.dart';
// import 'package:todoapp/utils/utils.dart';

// import 'package:flutter_native_timezone/flutter_native_timezone.dart'; //get the local timezone of the os (ej: GMT)
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class InitialPage extends GetView<InitialPageController> {
//   const InitialPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       /// Appbar
//       appBar: AppBar(
//         leadingWidth: 300,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 16),
//           child: SvgPicture.asset(
//             'assets/weekly-logo.svg',
//             alignment: Alignment.center,
//             color: Colors.black,
//           ),
//         ),
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // LocalNotificationService.showtNotificationNow(
//           //   id: Utils.createNotificationId(),
//           //   title: 'Notification NOW',
//           //   body: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.',
//           //   payload: '/secondPage',
//           //   fln: localNotifications,
//           // );
//           print(tz.TZDateTime.from(DateTime.now(), tz.local));
//           print(DateTime.now());
//           print(tz.local);
//         },
//       ),

//       // drawer o sidebar
//       endDrawer: const SideBar(),

//       // dias + tareas
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             /// HEADER
//             Obx(
//               () => Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: controller.addWeeks == 0
//                         ? () {}
//                         : () {
//                             controller.addWeeks--;
//                             controller.buildInfo(); //addWks: controller.addWeeks
//                           },
//                     icon: Icon(
//                       Icons.arrow_back_ios,
//                       color: controller.addWeeks == 0 ? disabledColorLight : null,
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       Text(controller.weekDaysFromTo.value),
//                       Text(controller.tasksPercentageCompleted.value),
//                     ],
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       controller.addWeeks++;
//                       controller.buildInfo(); //addWks: controller.addWeeks
//                     },
//                     icon: const Icon(Icons.arrow_forward_ios),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(height: 40),

//             /// DIAS + TAREAS
//             GetBuilder<InitialPageController>(
//               id: 'buildInfo',
//               builder: (ctrlr) {
//                 return ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   key: ctrlr.key,
//                   shrinkWrap: true,
//                   itemCount: ctrlr.buildWeek.length,
                  
//                   itemBuilder: (BuildContext context, int index) {
//                     ////////
//                     DateTime currentKey = ctrlr.buildWeek.keys.toList()[index];
//                     List<Task> currentValue = [];
//                     currentValue.addAll(ctrlr.buildWeek[currentKey]!);
//                     GlobalKey<AnimatedListState> key = GlobalKey();

//                     bool isDateEnabled = currentKey.isBefore(DateTime.now().subtract(const Duration(days: 1))) ? false : true;

//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         /// SHOW DATE
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               RichText(
//                                 text: TextSpan(
//                                   text: '> ${DateFormat('EEEE').format(currentKey)}',
//                                   style: TextStyle(fontSize: 18, color: isDateEnabled ? Colors.black : disabledColorDark),
//                                   children: <TextSpan>[
//                                     TextSpan(
//                                       text: '   ${DateFormat('MM-dd-yy').format(currentKey)}',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: isDateEnabled ? Colors.black : disabledColorDark,
//                                         fontStyle: FontStyle.italic,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               isDateEnabled
//                                   ? customAddIcon(onPressed: () => ctrlr.navigate(date: currentKey))
//                                   : Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Icon(
//                                         Icons.add,
//                                         color: disabledColorLight,
//                                       ),
//                                     ),
//                             ],
//                           ),
//                         ),

//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           child: Stack(
//                             alignment: Alignment.topCenter,
//                             children: [
//                               /// SHOW NO TASKS
//                               Container(
//                                 key: UniqueKey(),
//                                 height: 50,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.4),
//                                   borderRadius: const BorderRadius.all(Radius.circular(5)),
//                                 ),
//                                 alignment: Alignment.centerLeft,
//                                 padding: const EdgeInsets.all(16),
//                                 child: const Text(
//                                   'No hay tareas',
//                                   style: TextStyle(color: Colors.grey),
//                                 ),
//                               ),

//                               /// SHOW TASKS IF EXISTS
//                               currentValue.isNotEmpty
//                                   ? AnimatedList(
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       initialItemCount: currentValue.length,
//                                       shrinkWrap: true,
//                                       key: key,
//                                       itemBuilder: (context, index2, animation) {
//                                         /// CREATE ITEMS
//                                         Task task = currentValue[index2];
//                                         int idx = ctrlr.getTasks.indexOf(task);

//                                         return Padding(
//                                           padding: const EdgeInsets.only(bottom: 8),
//                                           child: TaskCardWidget(
//                                             key: UniqueKey(),
//                                             tarea: task,
//                                             index: idx,
//                                             onStatusChange: () => ctrlr.createCompletedTasksPercentage(),
//                                             onRemove: () {
//                                               showCustomDialog(
//                                                 context: context,
//                                                 description: 'Se eliminará la tarea para el día ${Utils.parseDateToString(task.dateTime)}',
//                                                 title: 'Eliminar tarea ?',
//                                                 callBack: () {
//                                                   key.currentState?.removeItem(
//                                                     index2,
//                                                     duration: const Duration(milliseconds: 300),
//                                                     (BuildContext context, animation) {
//                                                       return ClipRRect(
//                                                         borderRadius: const BorderRadius.all(Radius.circular(8)),
//                                                         child: SizeTransition(
//                                                           sizeFactor: animation,
//                                                           axisAlignment: -1,
//                                                           child: ColorFiltered(
//                                                             colorFilter: ColorFilter.mode(Colors.red.withOpacity(0.5), BlendMode.modulate),
//                                                             // duplicate TaskCardWidget as a children for animation purpose
//                                                             // child: TaskCardWidget(
//                                                             //   tarea: task,
//                                                             //   index: idx,
//                                                             //   isExpanded: true,
//                                                             //   onRemove: () {},
//                                                             // ),
//                                                             child: TaskCard(
//                                                               task: task,
//                                                             )
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                   );
//                                                   task.delete();
//                                                   ctrlr.buildInfo();
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                     )
//                                   : const SizedBox(),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // eliminar tarea modal
//   Future<dynamic> showCustomDialog({
//     required BuildContext context,
//     required VoidCallback callBack,
//     required String description,
//     required String title,
//   }) {
//     return showDialog(
//       context: context,
//       builder: (_) {
//         return CustomDialog(
//           title: title,
//           content: Text(description),
//           okCallBack: callBack,
//         );
//       },
//     );
//   }
// }
