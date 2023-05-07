import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';

class FormAppbar extends GetView<FormsPageController> implements PreferredSizeWidget {
  const FormAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppBar(
        // title
        title: Text(
          taskState(),
          style: kTitleLarge,
        ),

        // create or update task
        actions: [
          controller.isViewMode.value
              ? Wrap(
                  children: [
                    IconButton(
                      onPressed: () {
                        myCustomDialog(
                          context: context,
                          title: 'this action will delete...'.tr,
                          cancelTextButton: 'cancel'.tr,
                          okTextButton: 'delete'.tr,
                          iconPath: 'assets/warning.svg',
                          iconColor: warning,
                          onPressOk: () => controller.deleteTask(),
                          content: controller.getTask.repeatId != null ? const _BuildCheckBox() : null,
                          //subtitle: controller.getTask.repeatId != null ? 'Esta es una tarea periódica' : null,
                        );
                      },
                      icon: const Icon(Icons.delete_forever, color: textBg),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.floatingActionButtonChangeMode();
                        controller.enableDisableNotificationStyles();
                      },
                      icon: const Icon(Icons.mode_edit_rounded),
                    ),
                  ],
                )
              : controller.isUpdateMode.value
                  ? IconButton(
                      onPressed: () {
                        controller.floatingActionButtonChangeMode();
                        controller.enableDisableNotificationStyles();
                      },
                      icon: const Icon(Icons.edit_off_rounded),
                    )
                  : IconButton(
                      onPressed: () => controller.cancelAndNavigate(context),
                      icon: const Icon(Icons.home),
                    ),
        ],
      );
    });
  }

  String taskState() {
    if (controller.currentPageMode.value == PageMode.UPDATE_MODE) {
      return 'update task'.tr;
    }
    if (controller.currentPageMode.value == PageMode.VIEW_MODE) {
      return 'view task'.tr;
    }
    return 'new task_formPage'.tr;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// default value: [kToolbarHeight]
}

class _BuildCheckBox extends GetView<FormsPageController> {
  const _BuildCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
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
        ));
  }
}
