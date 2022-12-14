import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';
import 'package:todoapp/ui/widgets/alert_dialog.dart';
import 'package:todoapp/ui/widgets/side_bar.dart';
import 'package:todoapp/ui/widgets/task_card_widget.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/utils/parse_date_utils.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);
  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final InitialPageController _controller = Get.put(InitialPageController());

  @override
  void initState() {
    setState(() {
      _controller.buildInfo(addWeeks: _controller.addWeeks);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Appbar
      appBar: AppBar(
        leadingWidth: 300,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset(
            'assets/weekly-logo.svg',
            alignment: Alignment.center,
            color: Colors.black,
          ),
        ),
      ),

      // drawer o sidebar
      endDrawer: const SideBar(),

      // dias + tareas
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            /// HEADER
            //const HeadWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _controller.addWeeks == 0
                      ? () {}
                      : () {
                          _controller.addWeeks--;
                          _controller.buildInfo(addWeeks: _controller.addWeeks);
                          setState(() {});
                        },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: _controller.addWeeks == 0 ? disabledColorLight : null,
                  ),
                ),
                Column(
                  children: [
                    Text(_controller.weekDaysFromTo.value),
                    Text(_controller.tasksPercentageCompleted.value),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    _controller.addWeeks++;
                    _controller.buildInfo(addWeeks: _controller.addWeeks);
                    setState(() {});
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const Divider(height: 40),

            /// DIAS + TAREAS
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              key: _controller.key,
              shrinkWrap: true,
              itemCount: _controller.buildWeek.length,
              itemBuilder: (BuildContext context, int index) {
                ////////
                DateTime currentKey = _controller.buildWeek.keys.toList()[index];
                List<Task> currentValue = [];
                currentValue.addAll(_controller.buildWeek[currentKey]!);
                GlobalKey<AnimatedListState> key = GlobalKey();

                bool isDateEnabled = currentKey.isBefore(DateTime.now().subtract(const Duration(days: 1))) ? false : true;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SHOW DATE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '> ${DateFormat('EEEE').format(currentKey)}',
                              style: TextStyle(fontSize: 18, color: isDateEnabled ? Colors.black : disabledColorDark),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '   ${DateFormat('MM-dd-yy').format(currentKey)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDateEnabled ? Colors.black : disabledColorDark,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isDateEnabled
                              ? customAddIcon(onPressed: () => _controller.navigate(date: currentKey))
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.add,
                                    color: disabledColorLight,
                                  ),
                                ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          /// SHOW NO TASKS
                          Container(
                            key: UniqueKey(),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(16),
                            child: const Text(
                              'No hay tareas',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),

                          /// SHOW TASKS IF EXISTS
                          currentValue.isNotEmpty
                              ? AnimatedList(
                                  physics: const NeverScrollableScrollPhysics(),
                                  initialItemCount: currentValue.length,
                                  shrinkWrap: true,
                                  key: key,
                                  itemBuilder: (context, index2, animation) {
                                    /// CREATE ITEMS
                                    Task task = currentValue[index2];
                                    int idx = _controller.getTasks.indexOf(task);

                                    return TaskCardWidget(
                                      key: UniqueKey(),
                                      tarea: task,
                                      index: idx,
                                      onStatusChange: () => _controller.createCompletedTasksPercentage(),
                                      onRemove: () {
                                        showCustomDialog(
                                          context: context,
                                          description: 'Se eliminará la tarea para el día ${ParseDateUtils.dateToString(task.dateTime)}',
                                          title: 'Eliminar tarea ?',
                                          callBack: () {
                                            task.delete();
                                            _controller.buildInfo();
                                            key.currentState?.removeItem(
                                              index2,
                                              duration: const Duration(milliseconds: 300),
                                              (BuildContext context, animation) {
                                                return ClipRRect(
                                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                  child: SizeTransition(
                                                    sizeFactor: animation,
                                                    axisAlignment: -1,
                                                    child: ColorFiltered(
                                                      colorFilter: ColorFilter.mode(Colors.red.withOpacity(0.5), BlendMode.modulate),
                                                      // duplicate TaskCardWidget as a children for animation purpose
                                                      child: TaskCardWidget(
                                                        tarea: task,
                                                        index: idx,
                                                        isExpanded: true,
                                                        onRemove: () {},
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // eliminar tarea modal
  Future<dynamic> showCustomDialog({
    required BuildContext context,
    required VoidCallback callBack,
    required String description,
    required String title,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return CustomDialog(
          title: title,
          content: Text(description),
          okCallBack: callBack,
        );
      },
    );
  }
}

// class HeadWidget extends GetView<InitialPageController> {
//   const HeadWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () {
//         //print('Semana ${controller.currentWeek.value.weekNumber} - ${controller.currentWeek.value.weekNumber}');
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               onPressed: controller.addWeeks == 0
//                   ? () {}
//                   : () {
//                       controller.addWeeks--;
//                       controller.buildInfo(addWeeks: controller.addWeeks);
//                     },
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: controller.addWeeks == 0 ? disabledColorLight : null,
//               ),
//             ),
//             Column(
//               children: [
//                 Text(controller.weekDaysFromTo.value),
//                 Text(controller.tasksPercentageCompleted.value),
//               ],
//             ),
//             IconButton(
//               onPressed: () {
//                 controller.addWeeks++;
//                 controller.buildInfo(addWeeks: controller.addWeeks);
//               },
//               icon: const Icon(Icons.arrow_forward_ios),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
