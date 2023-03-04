import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/components/form_appbar.dart';
import 'package:todoapp/ui/form_page/components/set_notification.dart';
import 'package:todoapp/ui/form_page/components/task_fom.dart';
import 'package:todoapp/ui/form_page/components/todo_list.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';

class FormPageA extends GetView<FormsPageController> {
  const FormPageA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.onWillPop(context),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // appbar
          appBar: const FormAppbar(),

          // edit button
          floatingActionButton: Visibility(
            visible: controller.isViewMode.value || controller.isUpdateMode.value,
            child: Obx(
              () => FloatingActionButton(
                onPressed: () {
                  controller.floatingActionButtonChangeMode();
                  controller.enableDisableNotificationStyles();
                },
                backgroundColor: controller.isViewMode.value ? yellow_primary : blue_primary,
                child: Icon(
                  controller.isViewMode.value ? Icons.mode_edit_rounded : Icons.edit_off_rounded,
                  color: text_bg,
                ),
              ),
            ),
          ),

          // content
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // notification
                SetNotificationDatetime(),
                Divider(height: 50),

                // textfield
                TaskForm(),
                Divider(height: 20),

                // todo list
                TodoList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
