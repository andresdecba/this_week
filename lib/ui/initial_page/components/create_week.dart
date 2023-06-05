import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/create_task_page/create_task_page.dart';
import 'package:todoapp/ui/create_task_page/create_task_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/task_card.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/my_modal_bottom_sheet.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';
import 'package:todoapp/utils/helpers.dart';

class CreateWeek extends StatefulWidget {
  const CreateWeek({
    required this.week,
    required this.tasks,
    Key? key,
  }) : super(key: key);

  final Week week;
  final RxList<Rx<TaskModel>> tasks;

  @override
  State<CreateWeek> createState() => _CreateWeekState();
}

class _CreateWeekState extends State<CreateWeek> {
  final controller = Get.find<InitialPageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // no borrar //
      var noBorrar = controller.weekDaysFromTo;
      debugPrint('no borrar $noBorrar');

      return SingleChildScrollView(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 3, 0),
                    child: Row(
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
                                icon: const Icon(Icons.add),
                                visualDensity: VisualDensity.compact,
                                disabledColor: whiteBg.withOpacity(0),
                                onPressed: null,
                              )

                            /// CREATE TASK
                            : IconButton(
                                icon: Icon(Icons.add, color: isToday ? bluePrimary : disabledGrey),
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  Get.put(CreateTaskPageController(selectedDate: e));
                                  myModalBottomSheet(
                                    context: context,
                                    child: const CreateTaskPage(),
                                    enableDrag: true,
                                  );
                                },
                              ),
                      ],
                    ),
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
                          color: isToday ? bluePrimary.withOpacity(0.25) : Colors.grey[200],
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'no tasks'.tr,
                          style: kBodyMedium.copyWith(color: isToday ? whiteBg : disabledGrey),
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

                  const SizedBox(height: 12),
                ],
              );
            })
          ],
        ),
      );
    });
  }
}
