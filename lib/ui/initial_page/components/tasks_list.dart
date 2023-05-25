import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/create_task_page/create_task_page.dart';
import 'package:todoapp/ui/create_task_page/create_task_page_controller.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/task_card.dart';
import 'package:todoapp/ui/open_task.dart/view_task.dart';
import 'package:todoapp/ui/open_task.dart/view_task_controller.dart';
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

                                /////////// ***** CREATE TRASK ****** /////////////

                                onPressed: () {
                                  // enviar el dia seleccionado
                                  Get.find<CreateTaskPageController>().selectedDate = currentDate;
                                  // abrir crear bottomsheet
                                  showModalBottomSheet<dynamic>(
                                    isDismissible: false,
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    builder: (context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: Stack(
                                            children: [
                                              const CreateTaskPage(),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: IconButton(
                                                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                                  onPressed: () => Get.find<CreateTaskPageController>().closeAndRestoreValues(),
                                                  icon: const Icon(
                                                    Icons.close_rounded,
                                                    color: disabledGrey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
                                    navigate: () {
                                      Get.find<ViewTaskController>().task = e;
                                      openBottomSheetWithScroll(
                                        context: context,
                                        initialChildSize: 0.9,
                                        widget: const ViewTask(),
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
              ],
            );
          },
        );
      },
    );
  }
}

InputDecoration _myInputDecoration({
  required String hintText,
  required VoidCallback clearText,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(8),
    isDense: true,
    border: const OutlineInputBorder(),
    alignLabelWithHint: true,
    hintText: hintText,
    hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
    counterText: "",
    suffixIconConstraints: const BoxConstraints(maxHeight: 100),
    suffixIcon: InkWell(
      onTap: () => clearText(),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Icon(Icons.close_rounded, size: 20),
      ),
    ),
    counterStyle: const TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 10,
      height: double.minPositive,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: disabledGrey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: bluePrimary),
    ),
  );
}
