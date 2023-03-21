import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/task_card.dart';
import 'package:todoapp/utils/helpers.dart';

class TasksList extends GetView<InitialPageController> {
  const TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          key: controller.keyScroll,
          shrinkWrap: true,
          itemCount: controller.buildWeek.value.length,
          itemBuilder: (context, index) {
            //
            DateTime currentDate = controller.buildWeek.value.keys.toList()[index];
            List<Task> tasks = [];
            tasks.addAll(controller.buildWeek.value[currentDate]!);
            // si es el dia de ayer y no tiene una tarea, esconder ese dia
            bool hideEmptyYesterday = (currentDate.isBefore(DateTime.now().subtract(const Duration(days: 1))) && tasks.isEmpty) ? true : false;
            // si es el dia de ayer pero si tiene tareas, deshabilitar el dia
            bool disableYesterday = (currentDate.isBefore(DateTime.now().subtract(const Duration(days: 1))) && tasks.isNotEmpty) ? true : false;

            // crear en una columna todos los dias con sus respectivas tareas
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// SHOW DATE
                if (!hideEmptyYesterday)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: weekdayOnlyFormater(currentDate),
                            style: kTitleMedium.copyWith(color: disableYesterday ? disabled_grey : text_bg, fontSize: 17),
                          children: <TextSpan>[
                            TextSpan(
                              text: '   ${standardDateFormater(currentDate)}',
                              style: kBodySmall.copyWith(
                                fontStyle: FontStyle.italic,
                                  color: disableYesterday ? disabled_grey : text_bg,
                              ), //ktitleSmall!.copyWith(color: isDateEnabled ? text_bg : disabled_grey),
                            ),
                          ],
                        ),
                      ),
                        disableYesterday
                            ? const IconButton(
                              onPressed: null,
                              visualDensity: VisualDensity.compact,
                              disabledColor: disabled_grey,
                              icon: Icon(Icons.add),
                              )
                            : IconButton(
                                icon: const Icon(Icons.add_circle_rounded),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => controller.navigate(date: currentDate),
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
                      if (!hideEmptyYesterday)
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
                            'no tasks'.tr,
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
                                      //isDisabled: disableYesterday,
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
}
