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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              enabled: controller.isUpdateMode.value || controller.isNewMode.value,
              controller: controller.taskDescriptionCtrlr,
              decoration: customInputDecoration(
                hasBorder: controller.isUpdateMode.value || controller.isNewMode.value,
                label: 'Task description',
                hintText: 'Add a task description between 7 and 200 characters.',
                clearText: () {
                  controller.taskDescriptionCtrlr.clear();
                  controller.hasUserInteraction.value = false;
                },
                isEnabled: controller.isUpdateMode.value || controller.isNewMode.value,
              ),
              maxLines: 6,
              maxLength: 200,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              style: kTitleMedium,
              validator: (value) {
                if (value != null && value.length < 7) {
                  return 'Write at least 7 characters';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                value.length >= 7 ? controller.hasUserInteraction.value = true : controller.hasUserInteraction.value = false;
              },
            ),
          ),
        ],
      );
    });
  }
}
