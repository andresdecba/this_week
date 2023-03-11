import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';
import 'package:todoapp/utils/helpers.dart';

class NotificationAndDatePicker extends GetView<FormsPageController> {
  const NotificationAndDatePicker({Key? key}) : super(key: key);

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
            // notify picker //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  key: UniqueKey(),
                  onTap: controller.isViewMode.value ? null : () => getTimePicker(context),
                  child: controller.notificationText.value,
                ),
                IconButton(
                  icon: controller.notificationIcon.value,
                  color: controller.notificationColor.value,
                  visualDensity: VisualDensity.compact,
                  onPressed: controller.isViewMode.value
                      ? null
                      : () {
                          controller.enableNotificationIcon.value = !controller.enableNotificationIcon.value;
                          controller.enableDisableNotificationStyles();
                          controller.saveNotification();
                        },
                ),
              ],
            ),

            // date picker //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  longDateFormater(controller.taskDate.value),
                  //style: controller.hasDateChanged.value ? newDateTxtStyle : noDateTxtStyle,
                ),
                IconButton(
                  icon: const Icon(Icons.date_range_rounded),
                  visualDensity: VisualDensity.compact,
                  onPressed: controller.isViewMode.value
                      ? null
                      : () {
                          selectDate(context);
                        },
                ),
              ],
            ),
          ],
        ),
      ]);
    });
  }

  Future<void> selectDate(BuildContext context) async {
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

  Future<void> getTimePicker(BuildContext context) async {
    FocusScope.of(context).unfocus(); // hide keyboard if open
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: controller.setNotificationTime,
    );
    if (newTime == null) {
      return;
    } else {
      controller.setNotificationTime = newTime;
    }
    controller.enableDisableNotificationStyles();
    controller.saveNotification();
  }
}
