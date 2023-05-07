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
          itemCount: controller.buildWeekInUI.value.length,
          itemBuilder: (context, index) {
            //
            DateTime currentDate = controller.buildWeekInUI.value.keys.toList()[index];
            List<TaskModel> tasks = [];
            tasks.addAll(controller.buildWeekInUI.value[currentDate]!);
            // si es el dia de ayer y no tiene una tarea, esconder ese dia
            bool hideEmptyYesterday = (currentDate.isBefore(DateTime.now().subtract(const Duration(days: 1))) && tasks.isEmpty) ? true : false;
            // si es el dia de ayer pero si tiene tareas, deshabilitar el dia
            bool disableYesterday = (currentDate.isBefore(DateTime.now().subtract(const Duration(days: 1))) && tasks.isNotEmpty) ? true : false;

            // crear en una columna todos los dias con sus respectivas tareas
            return Column(
              children: [

                /// THERE WHERENT TASKS
                Visibility(
                  visible: hideEmptyYesterday,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: weekdayOnlyFormater(currentDate),
                                style: kTitleMedium.copyWith(
                                  color: disabledGrey,
                                  fontSize: 17,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '  ${standardDateFormater(currentDate)}: ${'there were no tasks'.tr}',
                                    style: kBodySmall.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: disabledGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 38),
                          ],
                        ),
                      ),
                      const Divider(height: 0, thickness: 1),
                    ],
                  ),
                ),

                /// SHOW WEEKDAY AND DATE
                Visibility(
                  visible: !hideEmptyYesterday,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: weekdayOnlyFormater(currentDate),
                            style: kTitleMedium.copyWith(color: disableYesterday ? disabledGrey : textBg, fontSize: 17),
                            children: <TextSpan>[
                              TextSpan(
                                text: '   ${standardDateFormater(currentDate)}',
                                style: kBodySmall.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: disableYesterday ? disabledGrey : textBg,
                                ), 
                              ),
                            ],
                          ),
                        ),
                        disableYesterday
                            ? const IconButton(
                                onPressed: null,
                                visualDensity: VisualDensity.compact,
                                disabledColor: disabledGrey,
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
                ),
            
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    /// SHOW NO TASKS
                    Visibility(
                      visible: !hideEmptyYesterday,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
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
                            style: kTitleSmall.copyWith(color: disabledGrey, fontStyle: FontStyle.italic),
                          ),
                        ),
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
                                    // navigate: () => openBottomSheetWithScroll(
                                    //   context: context,
                                    //   initialChildSize: 0.7,
                                    //   widget: ViewTask(task: e),
                                    // ),
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
