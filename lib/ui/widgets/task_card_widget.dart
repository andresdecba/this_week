import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';
import 'package:todoapp/ui/controllers/initial_page_week_controller.dart';

class TaskCard extends GetView<InitialPageWeekController> {
  const TaskCard({required this.tarea, required this.index, Key? key}) : super(key: key);

  final Task tarea;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
          //key: ValueKey(tsk.key.toString()),
          padding: const EdgeInsets.all(20),
          color: Colors.grey,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // title + icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Title: ${tarea.title}'),
                        Wrap(
                          children: [
                            IconButton(
                              onPressed: () {
                                tarea.delete();
                                controller.removeTask(index);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () => controller.navigate(taskKey: tarea.key),
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(),
                    // description
                    Text('Description: ${tarea.description}'),
                    const Divider(),
                    Text('Description: ${tarea.dateTime}'),
                    const Divider(),
                    // subtasks
                    ListView(
                      shrinkWrap: true,
                      children: tarea.subTasks.map((e) => Text(e.title)).toList(),
                    ),
                  ],
                ),
              ),
              // drag handle
              ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              )
            ],
          ),
        );
  }
}
