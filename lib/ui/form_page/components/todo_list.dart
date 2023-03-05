import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';
import 'package:todoapp/ui/shared_components/alert_dialog.dart';

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
              'Todo list',
              style: kTitleLarge,
            ),
            IconButton(
              onPressed: () => showSubtaskDialog(
                context: context,
                onOk: () => controller.createSubtask(),
                controller: controller,
              ),
              icon: const Icon(Icons.add_circle_rounded),
            ),
          ],
        ),
        const SizedBox(height: 30),
        // CREATE LIST
        Obx(
          () => controller.getTask.subTasks.isEmpty //controller.subTasks.value.isEmpty
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
                    'Here you can add a sub tasks list',
                    style: kTitleSmall.copyWith(color: disabled_grey, fontStyle: FontStyle.italic),
                  ),
                )
              // SHOW TASKS
              : Wrap(
                  children: [
                    const Divider(thickness: 1, height: 0),
                    ListView.separated(
                      separatorBuilder: (context, i) => const Divider(thickness: 1, height: 0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.getTask.subTasks.length, //controller.subTasks.value.length,
                      itemBuilder: (BuildContext context, int i) {
                        SubTask subTask = controller.getTask.subTasks[i]; //controller.subTasks.value[i];

                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            // if (direction == DismissDirection.endToStart) {
                            //   controller.fillSubTaskTFWhenUpdate(i);
                            //   showSubtaskDialog(context, () {});
                            // }
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
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            onLongPress: () {
                              controller.subTaskTitleCtrlr.text = subTask.title; //controller.updateSubtask(i);
                              showSubtaskDialog(
                                context: context,
                                onOk: () => controller.updateTextSubtask(i),
                                controller: controller,
                              );
                            },
                            leading: Checkbox(
                              shape: const CircleBorder(),
                              activeColor: status_task_done,
                              value: controller.getTask.subTasks[i].isDone, //controller.subTasks.value[i].isDone,
                              visualDensity: VisualDensity.compact,
                              onChanged: (value) {
                                controller.updateStatusSubtask(i);
                              },
                            ),
                            title: Text(
                              '$i - ${subTask.title}',
                              style: subTask.isDone ? kBodyMedium.copyWith(decoration: TextDecoration.lineThrough, fontStyle: FontStyle.italic, color: disabled_grey) : kBodyMedium,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(thickness: 1, height: 0),
                  ],
                ),
        ),
      ],
    );
  }
}

// crear subtarea modal
Future<dynamic> showSubtaskDialog({
  required FormsPageController controller,
  required BuildContext context,
  required VoidCallback onOk,
}) {
  return showDialog(
    context: context,
    builder: (_) {
      return CustomDialog(
        description: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Text('Agregar una subtarea'),
              SizedBox(height: 30),
              SubTaskForms(),
            ],
          ),
        ),
        okCallBack: () {
          onOk();
          controller.onCancelSubtask(context);
        },
        cancelCallBack: () => controller.onCancelSubtask(context),
      );
    },
  );
}

// textfield de la subtarea
class SubTaskForms extends GetView<FormsPageController> {
  const SubTaskForms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: controller.subTaskTitleCtrlr,
            enabled: true,
            maxLines: 4,
            decoration: customInputDecoration(
              label: 'Subtarea',
              hintText: 'Ingresar descripcion de la subtarea',
              clearText: () => controller.subTaskTitleCtrlr.clear(),
              isEnabled: true,
              hasBorder: true,
            ),
            maxLength: 100,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            autofocus: true,
          ),
        ],
      ),
    );
  }
}
