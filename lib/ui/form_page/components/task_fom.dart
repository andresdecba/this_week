import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';

class TaskForm extends GetView<FormsPageController> {
  const TaskForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        children: [
          Text(
            'Task description',
            style: kTitleLarge,
          ),
          const SizedBox(height: 40),
          Form(
            key: controller.formKey,
            child: TextFormField(
              enabled: controller.isUpdateMode.value || controller.isNewMode.value,
              controller: controller.taskDescriptionCtrlr,
              decoration: customInputDecoration(
                hasBorder: controller.isUpdateMode.value || controller.isNewMode.value,
                label: 'Task description',
                hintText: 'Add a task description in 200 characters or less.',
                clearText: () => controller.taskDescriptionCtrlr.clear(),
                isEnabled: controller.isUpdateMode.value || controller.isNewMode.value,
              ),
              maxLines: 6,
              maxLength: 200,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              style: kTitleMedium,
            ),
          ),
        ],
      );
    });
  }
}
