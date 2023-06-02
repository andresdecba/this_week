import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/create_task_page/create_task_page.dart';
import 'package:todoapp/ui/create_task_page/create_task_page_controller.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/task_card.dart';
import 'package:todoapp/ui/shared_components/my_modal_bottom_sheet.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';
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
            tasks.addAll(controller.tasksMap[currentDate]!);

            // si es el dia de hoy
            var today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
            bool isToday = currentDate.isAtSameMomentAs(today);

            // deshabilitar los dias anteriores a hoy
            bool disableAddNewTask = (currentDate.isBefore(today)) ? true : false;


            // crear en una columna todos los dias con sus respectivas tareas
            return Column(
              children: [
                /// SHOW WEEKDAY AND DATE
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: weekdayOnlyFormater(currentDate),
                          style: isToday ? kTitleLarge.copyWith(color: bluePrimary) : kTitleLarge,
                          children: <TextSpan>[
                            TextSpan(
                              text: '   ${standardDateFormater(currentDate)}',
                              style: isToday ? kBodySmall.copyWith(color: bluePrimary) : kBodySmall,
                            ),
                          ],
                        ),
                      ),
                      disableAddNewTask
                          ? const IconButton(
                              onPressed: null,
                              visualDensity: VisualDensity.compact,
                              disabledColor: disabledGrey,
                              icon: Icon(Icons.add),
                            )

                          /// CREATE TASK
                          : IconButton(
                              icon: const Icon(Icons.add_circle_rounded),
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                Get.put(CreateTaskPageController(selectedDate: currentDate));
                                myModalBottomSheet(
                                  context: context,
                                  child: CreateTaskPage(),
                                  enableDrag: true,
                                );
                              },
                            ),
                    ],
                  ),
                ),

                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    /// SHOW NO TASKS
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        key: UniqueKey(),
                        //height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'no tasks'.tr,
                          style: kBodyMedium.copyWith(color: disabledGrey),
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
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: TaskCard(
                                    isToday: isToday,
                                    key: UniqueKey(),
                                    task: e.value,
                                    navigate: () {
                                      Get.put(ViewTaskController(task: e));
                                      myModalBottomSheet(
                                        context: context,
                                        child: const ViewTask(),
                                      );
                                    },
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
                // const Divider(
                //   color: Colors.black,
                //   height: 0,
                //   thickness: 1,
                // ),
              ],
            );
          },
        );
      },
    );
  }
}
