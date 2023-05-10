import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/task_card.dart';
import 'package:todoapp/ui/open_task.dart/open_task.dart';
import 'package:todoapp/ui/shared_components/bottomsheet_with_scroll.dart';
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
          itemCount: controller.tasksMap.length,
          itemBuilder: (context, index) {
            //
            DateTime currentDate = controller.tasksMap.keys.toList()[index];
            List<Rx<TaskModel>> tasks = [];
            //tasks.addAll(controller.tasksMap.value[currentDate]!);
            tasks.addAll(controller.tasksMap[currentDate]!);

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
                                    task: e.value,
                                    //navigate: () => controller.navigate(taskKey: e.value.key),
                                    navigate: () => openBottomSheetWithScroll(
                                      context: context,
                                      initialChildSize: 0.7,
                                      widget: OpenTask(task: e),
                                    ),
                                    onStatusChange: () {
                                      e.value.status = controller.changeTaskStatus(e.value.status);
                                      e.value.save();
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

 
}
