import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/view_task_page.dart/components/expandible_options_item.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';

enum _MenuItem {
  date,
  notification,
  delete,
}

class ExpandibleOptions extends GetView<ViewTaskController> {
  const ExpandibleOptions({
    required this.task,
    Key? key,
  }) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(

      position: PopupMenuPosition.under,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),

      // ejecutar
      onSelected: (value) {
        switch (value) {
          case _MenuItem.date:
            controller.updateTaskDate(context, task);
            break;
          case _MenuItem.notification:
            controller.updateTaskDate(context, task);
            break;
          case _MenuItem.delete:
            myCustomDialog(
              context: context,
              title: 'this action will delete...'.tr,
              cancelTextButton: 'cancel'.tr,
              okTextButton: 'delete'.tr,
              iconPath: 'assets/warning.svg',
              iconColor: warning,
              content: task.value.repeatId != null ? const _BuildCheckBox() : null,
              onPressOk: () {
                controller.deleteTask();
              },
            );
            break;
        }
      },

      // items
      itemBuilder: (context) {
        return [
          // CAMBIAR LA FECHA
          PopupMenuItem(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            value: _MenuItem.date,
            child: ExpandibleOptionsItem(
              title: 'Cambiar fecha'.tr, //longDateFormaterWithoutYear(task.value.taskDate),
              leading: Icons.calendar_today_rounded,
            ),
          ),

          // CAMBIAR LA NOTIFICACION
          PopupMenuItem(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            value: _MenuItem.date,
            child: ExpandibleOptionsItem(
              title: 'Notificacion'.tr,
              leading: Icons.notifications_active_rounded,
            ),
          ),

          // ELIMINAR TAREA
          PopupMenuItem(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            value: _MenuItem.delete,
            child: ExpandibleOptionsItem(
              title: 'Eliminar tarea'.tr,
              leading: Icons.delete_forever_outlined,
            ),
          ),
        ];
      },
    );
  }
}

class _BuildCheckBox extends GetView<ViewTaskController> {
  const _BuildCheckBox({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'this is a periodic task'.tr,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: controller.isChecked.value,
                onChanged: (value) => controller.isChecked.value = !controller.isChecked.value,
              ),
              Expanded(child: Text('delete current task and subsequent...'.tr)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: !controller.isChecked.value,
                onChanged: (value) => controller.isChecked.value = !controller.isChecked.value,
              ),
              Expanded(child: Text('delete current task'.tr)),
            ],
          ),
        ],
      ),
    );
  }
}
