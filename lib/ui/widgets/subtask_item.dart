import 'package:flutter/material.dart';
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
    return ReorderableDragStartListener(
      key: Key('$index'),
      index: index,
      child: Container(
        key: Key('$index'),
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 100),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        color: Colors.grey[350],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                controller.getSubTaskList.value[index].title,
              ),
            ),
            Row(
              children: [
                // editar subtask
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
                  icon: const Icon(Icons.close),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
