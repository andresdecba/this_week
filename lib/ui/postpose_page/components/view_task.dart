import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/utils/helpers.dart';

class ViewTask extends StatelessWidget {
  const ViewTask({required this.task, Key? key}) : super(key: key);
  final TaskModel task;

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // info de la tarea
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // dia
              _CustomTile(
                leading: const Icon(Icons.date_range_rounded),
                title: Text(
                  longDateFormaterWithoutYear(task.taskDate),
                  style: kBodyMedium,
                ),
              ),
              // hora notificacion
              task.notificationData != null
                  ?
                _CustomTile(
                      leading: const Icon(Icons.notifications_active_rounded),
                      title: Text(
                        timeFormater(task.notificationData!.time),
                        style: kBodyMedium,
                      ),
                    )
                  : _CustomTile(
                      leading: const Icon(Icons.notifications_off_rounded),
                      title: Text(
                        '--:--',
                        style: kBodyMedium,
                      ),
                    ),
              // status
              _CustomTile(
                leading: const Icon(Icons.keyboard_double_arrow_right_rounded),
                title: Text(
                  setStatusLanguage(task),
                  style: kBodyMedium,
                ),
              ),
              // tarea repetida
              if (task.repeatId != null)
                _CustomTile(
                  leading: const Icon(Icons.push_pin_rounded),
                  title: Text(
                    'Rutina',
                    style: kBodyMedium,
                  ),
                ),
            ],
          ),
        ),

        // divisor
        const Divider(
          color: blackBg,
          height: 0,
        ),

        // description + subtasks
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //descripcion y subtareas
                Text("${'task description'.tr}:"),
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                Text(
                  task.description,
                  style: kBodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Text("${'todo list'.tr}:"),
                const SizedBox(height: 10),
                if (task.subTasks.isNotEmpty)
                  ...task.subTasks.map((e) {
                    return _CustomTile(
                      title: Expanded(
                        child: Text(
                          e.title,
                          style: e.isDone ? kBodyMedium.copyWith(fontStyle: FontStyle.italic, decoration: TextDecoration.lineThrough) : kBodyMedium,
                        ),
                      ),
                      leading: e.isDone ? const Icon(Icons.check_circle_outline_rounded) : const Icon(Icons.circle_outlined),
                    );
                  }),
                if (task.subTasks.isEmpty)
                  Text(
                    'no subtasks'.tr,
                    style: kBodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomTile extends StatelessWidget {
  const _CustomTile({required this.leading, required this.title, Key? key}) : super(key: key);

  final Widget leading;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 20),
          title,
        ],
      ),
    );
  }
}
