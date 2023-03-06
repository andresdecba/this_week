import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/task_card.dart';

class TasksList extends StatefulWidget {
  const TasksList({Key? key}) : super(key: key);
  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    InitialPageController controller = Get.put(InitialPageController()); // Rather Controller controller = Controller();

    return GetBuilder<InitialPageController>(
      id: 'buildInfo',
      builder: (ctrlr) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          key: ctrlr.key,
          shrinkWrap: true,
          itemCount: ctrlr.buildWeek.length,
          itemBuilder: (context, index) {
            //
            DateTime currentDate = ctrlr.buildWeek.keys.toList()[index];
            List<Task> tasks = [];
            tasks.addAll(ctrlr.buildWeek[currentDate]!);
            bool isDateEnabled = currentDate.isBefore(DateTime.now().subtract(const Duration(days: 1))) ? false : true;

            //
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
                          text: '> ${DateFormat('EEEE').format(currentDate)}',
                          style: kTitleMedium.copyWith(color: isDateEnabled ? text_bg : disabled_grey),
                          children: <TextSpan>[
                            TextSpan(
                              text: '   ${DateFormat('MM-dd-yy').format(currentDate)}',
                              style: kBodySmall.copyWith(
                                fontStyle: FontStyle.italic,
                                color: isDateEnabled ? text_bg : disabled_grey,
                              ), //ktitleSmall!.copyWith(color: isDateEnabled ? text_bg : disabled_grey),
                            ),
                          ],
                        ),
                      ),
                      isDateEnabled
                          ? IconButton(
                              icon: const Icon(Icons.add_circle_rounded),
                              visualDensity: VisualDensity.compact,
                              onPressed: () => ctrlr.navigate(date: currentDate),
                              color: enabled_grey,
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add,
                                color: disabled_grey,
                              ),
                            ),
                    ],
                  ),
                ),

                //
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
                        child: Text(
                          'No hay tareas',
                          style: kTitleSmall.copyWith(color: disabled_grey, fontStyle: FontStyle.italic),
                        ),
                      ),

                      /// SHOW TASKS IF EXISTS
                      tasks.isNotEmpty
                          ? ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                ...tasks.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: TaskCard(
                                      key: UniqueKey(),
                                      task: e,
                                      navigate: () => controller.navigate(taskKey: e.key),
                                      onStatusChange: () {
                                        e.status = changeTaskStatus(e.status);
                                        e.save();
                                        controller.createCompletedTasksPercentage();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  String changeTaskStatus(String value) {
    switch (value) {
      case 'Pending':
        return TaskStatus.IN_PROGRESS.toValue;
      case 'In progress':
        return TaskStatus.DONE.toValue;
      case 'Done':
        return TaskStatus.PENDING.toValue;
      default:
        return TaskStatus.IN_PROGRESS.toValue;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
