import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/open_task.dart/view_task_controller.dart';
import 'package:todoapp/utils/helpers.dart';

class NotificationDetails extends GetView<ViewTaskController> {
  const NotificationDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                // cambiar notificacion //
                onTap: () => controller.notificationsUseCases.createUpdateNotificationUseCase(
                  task: controller.task,
                  context: context,
                ),
                child: Row(
                  children: [
                    // icon campanita activada/desactivada //
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        controller.task.value.notificationData != null ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                      ),
                    ),
                    // texto del widget //
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        controller.task.value.notificationData != null ? 'notificar a las ${timeFormater(controller.task.value.notificationData!.time)}' : 'Agregra notificación...',
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            // eliminar notifcation icon //
            Visibility(
              visible: controller.task.value.notificationData != null ? true : false,
              child: IconButton(
                onPressed: () => controller.notificationsUseCases.deleteNotificationUseCase(task: controller.task),
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ],
        ),
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    //   child: OptionsItemTile(
    //     title: task.value.notificationData != null ? timeFormater(task.value.notificationData!.time) : 'Agregra notificación...',

    //     leading: task.value.notificationData != null ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,

    //     trailing: IconButton(
    //       onPressed: () {},
    //       icon: const Icon(Icons.delete_forever_rounded),
    //     ),
    //     // open time picker
    //     //onTap: controller.isNotificationActive.value ? () => controller.timePicker(context) : null,
    //   ),
    // );
  }
}
