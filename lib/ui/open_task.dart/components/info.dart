import 'package:day_night_time_picker/day_night_time_picker.dart';
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
              onTap: () => datePicker(context),
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
              onTap: () => timePicker(context),
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

  Future<void> datePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: task.value.taskDate, // dia seleccionado
      firstDate: DateTime.now(), // primer dia habilitado
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 500,
              width: 350,
              child: child,
            ),
          ],
        );
      },
    );
    if (pickedDate == null) {
      return;
    } else {
      task.value.taskDate = pickedDate;
      task.refresh();
    }
  }

  Future<void> timePicker(BuildContext context) async {
    Time value = Time(
      hour: task.value.notificationTime?.hour ?? DateTime.now().hour,
      minute: task.value.notificationTime?.minute ?? DateTime.now().minute,
    );

    bool isTaskToday = task.value.taskDate.isAfter(DateTime.now());

    Navigator.of(context).push(
      showPicker(
        //accentColor: bluePrimary,
        borderRadius: 20,
        context: context,
        value: value,
        iosStylePicker: true,
        hourLabel: 'Hrs.',
        minuteLabel: 'Mins.',
        okStyle: kTitleLarge,
        cancelStyle: kTitleLarge,
        minHour: !isTaskToday ? DateTime.now().hour.toDouble() : 0,
        minMinute: !isTaskToday ? DateTime.now().minute.toDouble() + 5 : 0,
        onChange: (time) {
          var value = DateTime(
            task.value.notificationTime?.year ?? DateTime.now().year,
            task.value.notificationTime?.month ?? DateTime.now().month,
            task.value.notificationTime?.day ?? DateTime.now().day,
            time.hour,
            time.minute,
          );
          task.value.notificationTime = value;
          task.refresh();
        },
      ),
    );
  }
}
