import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';

class SetNotificationDatetime extends GetView<FormsPageController> {
  const SetNotificationDatetime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(children: [
        /// title ///
        Text(
          'Notify',
          style: kTitleLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: controller.notificationTime.value,
                );
                if (newTime == null) {
                  return;
                } else {
                  controller.setNotificationTime = newTime;
                }
              },
              child: controller.notificationText.value,
            ),
            IconButton(
              onPressed: () => controller.enableDisableNotificationStyles(),
              icon: controller.notificationIcon.value,
              color: controller.notificationColor.value,
            ),
          ],
        ),
      ]);
    });
  }
}
