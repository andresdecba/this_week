import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/components/info_item_tile.dart';
import 'package:todoapp/utils/helpers.dart';

class Info extends GetView<InitialPageController> {
  Info({required this.task, Key? key}) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
        child: Wrap(
          children: [
            // CAMBIAR LA FECHA
            InfoItemTile(
              title: longDateFormaterWithoutYear(task.value.taskDate),
              icon: Icons.calendar_today_rounded,
              onTap: () => controller.datePicker(context, task),
            ),
            const Divider(color: disabledGrey, height: 0),

            // CAMBIAR HORA DE LA NOTIFICACION
            InfoItemTile(
              title: task.value.notificationTime != null ? timeFormater(task.value.notificationTime!) : 'no hay',
              icon: controller.isNotificationActive.value ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
              trailing: Switch(
                value: controller.isNotificationActive.value,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  controller.isNotificationActive.value = value;
                },
              ),
              onTap: () => controller.timePicker(context, task),
            ),
            const Divider(color: disabledGrey, height: 0),

            // CAMBIAR EL STATUS
            InfoItemTile(
              title: task.value.status,
              icon: Icons.keyboard_double_arrow_right_rounded,
            ),

            // SI ES RUTINA
            Visibility(
              visible: task.value.repeatId != null ? true : false,
              child: Wrap(
                children: [
                  const Divider(color: disabledGrey, height: 0),
                  InfoItemTile(
                    title: 'Rutina',
                    icon: Icons.push_pin_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
