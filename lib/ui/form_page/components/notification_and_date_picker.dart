import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';
import 'package:todoapp/utils/helpers.dart';

class NotificationsAndDate extends GetView<FormsPageController> {
  const NotificationsAndDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(children: [
        //
        // title //
        Text(
          'notify me:'.tr,
          style: kTitleLarge,
        ),
        const SizedBox(height: 30),

        // elements
        Column(
          children: [
            // time picker //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  key: UniqueKey(),
                  onTap: controller.isViewMode.value ? null : () => timePicker(context),
                  child: controller.notificationText.value,
                ),
                IconButton(
                  disabledColor: black_bg,
                  icon: controller.notificationIcon.value,
                  color: controller.notificationColor.value,
                  visualDensity: VisualDensity.compact,
                  onPressed: controller.isViewMode.value
                      ? null
                      : () {
                          controller.enableNotificationIcon.value = !controller.enableNotificationIcon.value;
                          controller.enableDisableNotificationStyles();
                          controller.setNotificationValues();
                        },
                ),
              ],
            ),

            // date picker //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: controller.isViewMode.value
                      ? null
                      : () {
                          datePicker(context);
                        },
                  child: Text(
                    longDateFormater(controller.taskDate.value),
                    style: controller.isViewMode.value ? kBodyMedium : kBodyMedium.copyWith(color: blue_primary),
                  ),
                ),
                const IconButton(
                  icon: Icon(Icons.date_range_rounded),
                  visualDensity: VisualDensity.compact,
                  disabledColor: black_bg,
                  onPressed: null,
                ),
              ],
            ),

            // repeat date //
            Visibility(
              visible: controller.isNewMode.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${'repeat this task every'.tr} ${showDay()} ?',
                    style: kBodyMedium,
                  ),
                  Switch(
                    value: controller.isTaskRepeat.value,
                    onChanged: (value) {
                      controller.isTaskRepeat.value = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ]);
    });
  }

  String showDay() {
    var day = weekdayOnlyFormater(controller.taskDate.value);
    if (day == 'sábado') {
      return 'sábados';
    }
    if (day == 'domingo') {
      return 'domingos';
    }
    return day;
  }

  Future<void> datePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.getTask.taskDate,
      //firstDate: DateTime.now().subtract(Duration(days: 4)),
      firstDate: controller.isUpdateMode.value ? controller.getTask.taskDate : DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked == null) {
      //on cancel action
      return;
    } else {
      controller.taskDate.value = picked;
      controller.saveNewDate();
    }
  }

  Future<void> timePicker(BuildContext context) async {
    FocusScope.of(context).unfocus(); // hide keyboard if open
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: controller.isNewMode.value ? TimeOfDay(hour: controller.setNotificationTime.hour, minute: controller.setNotificationTime.minute + 5) : controller.setNotificationTime,
    );
    if (newTime == null) {
      return;
    } else {
      controller.setNotificationTime = newTime;
    }
    controller.enableDisableNotificationStyles();
    controller.setNotificationValues();
  }
}
