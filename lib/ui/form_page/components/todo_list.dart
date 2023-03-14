import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';

class TodoList extends GetView<FormsPageController> {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        // TITLE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'todo list'.tr,
              style: kTitleLarge,
            ),
            IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus(); // hide keyboard if open
                createSubtaskDialog(
                  context: context,
                  title: 'create subtask'.tr,
                  content: subtaskForm(),
                  cancelTextButton: 'cancel'.tr,
                  okTextButton: 'create'.tr,
                  onPressOk: () => controller.createSubtask(),
                );
              },
              icon: const Icon(Icons.add_circle_rounded),
            ),
          ],
        ),
        const SizedBox(height: 30),
        // CREATE LIST
        Obx(
          () => controller.getTask.subTasks.isEmpty
              // SHOW NO SUBTASKS
              ? Container(
                  key: UniqueKey(),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'here you can add a sub task list'.tr,
                    style: kBodyMedium.copyWith(color: disabled_grey, fontStyle: FontStyle.italic),
                  ),
                )
              // SHOW TASKS
              : Wrap(
                  children: [
                    const Divider(height: 0),
                    ListView.separated(
                      separatorBuilder: (context, i) => const Divider(height: 0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.getTask.subTasks.length,
                      itemBuilder: (BuildContext context, int i) {
                        SubTask subTask = controller.getTask.subTasks[i];

                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              controller.deleteSubtask(i);
                            }
                          },
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            color: warning,
                            child: const Icon(
                              Icons.delete_forever_rounded,
                              color: withe_bg,
                            ),
                          ),

                          //// CARD SUBTASK ////
                          child: ListTile(
                            key: UniqueKey(),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            onLongPress: () {
                              controller.subTaskTitleCtrlr.text = subTask.title;
                              FocusScope.of(context).unfocus(); // hide keyboard if open
                              createSubtaskDialog(
                                context: context,
                                title: 'update subtask'.tr,
                                content: subtaskForm(),
                                cancelTextButton: 'cancel'.tr,
                                okTextButton: 'update'.tr,
                                onPressOk: () => controller.updateTextSubtask(i),
                              );
                            },
                            leading: Checkbox(
                              shape: const CircleBorder(),
                              activeColor: status_task_done,
                              value: controller.getTask.subTasks[i].isDone,
                              visualDensity: VisualDensity.compact,
                              onChanged: (value) {
                                controller.updateStatusSubtask(i);
                              },
                            ),
                            title: Text(
                              '${i + 1} - ${subTask.title}',
                              style: subTask.isDone
                                  ? kBodyMedium.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      fontStyle: FontStyle.italic,
                                      color: disabled_grey,
                                    )
                                  : kBodyMedium.copyWith(
                                      color: enabled_grey,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 0),
                  ],
                ),
        ),
      ],
    );
  }

  Widget subtaskForm() {
    return Form(
      child: TextFormField(
        controller: controller.subTaskTitleCtrlr,
        enabled: true,
        maxLines: 4,
        decoration: customInputDecoration(
          label: 'Subtarea',
          hintText: 'create subtask_description'.tr,
          clearText: () => controller.subTaskTitleCtrlr.clear(),
          isEnabled: true,
          hasBorder: true,
        ),
        maxLength: 100,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        autofocus: true,
      ),
    );
  }
}
