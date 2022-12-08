import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/controllers/forms_page_controller.dart';
import 'package:todoapp/ui/pages/forms_page.dart';

class SubTaskItem extends StatelessWidget {
  const SubTaskItem({
    required this.index,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final int index;
  final FormsPageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('$index'),
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 100),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      decoration: boxDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.getSubTaskList.value[index].title,
                ),
              ),
              
            ],
          ),

          /// options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //move
              ReorderableDragStartListener(
                key: Key('$index'),
                index: index,
                child: const Icon(
                  Icons.drag_handle,
                  color: Colors.blueAccent,
                ),
              ),

              //done, edit, delete
              Wrap(
                children: [
                  IconButton(
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.check_circle_outline),
                    color: Colors.green[600],
                  ),
                  IconButton(
                    onPressed: () {
                      controller.fillSubTaskTFWhenUpdate(index);
                      showSubtaskDialog(context, () {});
                    },
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.edit),
                  ),
                  // eliminar subtask
                  IconButton(
                    onPressed: () => controller.deleteSubtask(index),
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_forever),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
