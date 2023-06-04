import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/components/task_card.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/my_modal_bottom_sheet.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';
import 'package:todoapp/utils/helpers.dart';

class PruebaNewList extends StatefulWidget {
  const PruebaNewList({
    required this.week,
    required this.tasks,
    Key? key,
  }) : super(key: key);

  final Week week;
  final List<Rx<TaskModel>> tasks;

  @override
  State<PruebaNewList> createState() => _PruebaNewListState();
}

class _PruebaNewListState extends State<PruebaNewList> {
  final InitialPageController controller = InitialPageController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// iteramos todos los dias de la semana para mostrarlos en una columna ///
            ...widget.week.days.map((e) {
              // si es el dia de hoy
              var today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              bool isToday = e.isAtSameMomentAs(today);

              // deshabilitar los dias anteriores a hoy
              bool disableAddNewTask = (e.isBefore(today)) ? true : false;

              // dias sin tareas
              bool hasTasks = false;
              for (var element in widget.tasks) {
                if (element.value.taskDate == e) {
                  hasTasks = true;
                }
              }

              // MOSTRAR DIAS //
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // MOSTRAR DIA //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: weekdayOnlyFormater(e),
                          style: isToday ? kTitleLarge.copyWith(color: bluePrimary) : kTitleLarge,
                          children: <TextSpan>[
                            TextSpan(
                              text: '   ${standardDateFormater(e)}',
                              style: isToday ? kBodySmall.copyWith(color: bluePrimary) : kBodySmall,
                            ),
                          ],
                        ),
                      ),
                      disableAddNewTask
                          ? IconButton(
                              onPressed: null,
                              visualDensity: VisualDensity.compact,
                              disabledColor: whiteBg.withOpacity(0),
                              icon: const Icon(Icons.add),
                            )

                          /// CREATE TASK
                          : IconButton(
                              icon: const Icon(Icons.add_circle_rounded),
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                // Get.put(CreateTaskPageController(selectedDate: currentDate));
                                // myModalBottomSheet(
                                //   context: context,
                                //   child: CreateTaskPage(),
                                //   enableDrag: true,
                                // );
                              },
                            ),
                    ],
                  ),

                  /// SHOW NO TASKS
                  if (!hasTasks)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        key: UniqueKey(),
                        //height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'no tasks'.tr,
                          style: kBodyMedium.copyWith(color: disabledGrey),
                        ),
                      ),
                    ),

                  // MOSTRAR TAREAS DE ESTE DIA "e" //
                  ...widget.tasks.map((task) {
                    if (task.value.taskDate == e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: TaskCard(
                          isToday: isToday,
                          key: UniqueKey(),
                          task: task.value,
                          navigate: () {
                            Get.put(ViewTaskController(task: task));
                            myModalBottomSheet(
                              context: context,
                              child: const ViewTask(),
                            );
                          },
                          onStatusChange: () {
                            task.value.status = controller.changeTaskStatus(task.value.status);
                            task.value.save();

                            /// TODO controller.createCompletedTasksPercentage();
                          },
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
