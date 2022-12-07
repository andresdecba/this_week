import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/ui/widgets/toggle_status_btn.dart';

// drag handle
// ReorderableDragStartListener(
//   index: index,
//   child: const Icon(Icons.drag_handle), or reorder
// )

class TaskCardWidget extends StatefulWidget {
  const TaskCardWidget({
    required this.tarea,
    required this.index,
    required this.onRemove,
    this.isExpanded,
    this.onStatusChange,
    Key? key,
  }) : super(key: key);

  final Task tarea;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback? onStatusChange;
  final bool? isExpanded;

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  final InitialPageController _controller = Get.put(InitialPageController());
  Color statusColor = Colors.grey;

  @override
  void initState() {
    setStatusColor();
    super.initState();
  }

  Color setStatusColor() {
    switch (widget.tarea.status) {
      case 'Pending':
        statusColor = Colors.grey;
        break;
      case 'In progress':
        statusColor = Colors.green;
        break;
      case 'Done':
        statusColor = Colors.orange;
        break;
    }
    setState(() {});
    return statusColor;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              color: statusColor,
              width: 3,
            ),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: widget.isExpanded ?? false,
          maintainState: true,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          textColor: Colors.black,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 26),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon(
              //   Icons.task_alt,
              //   size: 16,
              //   color: statusColor,
              // ),
              Expanded(
                child: Text(
                  widget.tarea.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(
              '10:00 - 13:00 hs.  ${DateFormat('MM-dd-yy').format(widget.tarea.dateTime)}',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 12,
              ),
            ),
          ),
          children: [
            /// descripcion de la tarea
            widget.tarea.description == ''
                ? const SizedBox()
                : Wrap(
                    children: [
                      Text(
                        widget.tarea.description,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),

            /// subtareas
            const Divider(height: 8),
            ...widget.tarea.subTasks.map(
              (element) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SubTaskWidget(
                    subtask: element,
                    task: widget.tarea,
                  ),
                  //const Divider(height: 0),
                ],
              ),
            ),
            const Divider(height: 8),

            /// task status button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return ToggleStatusButton(
                      task: widget.tarea,
                      onChanged: () {
                        setStatusColor();
                        widget.tarea.save();
                        if (widget.onStatusChange != null) {
                          widget.onStatusChange!();
                        }
                      },
                    );
                  }),
                ),
                Wrap(
                  children: [
                    IconButton(
                      // onPressed: () {
                      //   widget.tarea.delete();
                      //   _controller.dataList.removeAt(widget.index);
                      //   _controller.removeItem(index, child)
                      // },
                      onPressed: widget.onRemove,
                      icon: const Icon(Icons.delete),
                      iconSize: 16,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      onPressed: () => _controller.navigate(taskKey: widget.tarea.key),
                      icon: const Icon(Icons.edit),
                      iconSize: 16,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// subtasks widget
class _SubTaskWidget extends StatefulWidget {
  const _SubTaskWidget({
    required this.subtask,
    required this.task,
    Key? key,
  }) : super(key: key);

  final SubTask subtask;
  final Task task;

  @override
  State<_SubTaskWidget> createState() => _SubTaskWidgetState();
}

class _SubTaskWidgetState extends State<_SubTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: widget.subtask.isDone == true ? const Icon(Icons.circle) : const Icon(Icons.circle_outlined),
          visualDensity: VisualDensity.compact,
          iconSize: 9,
          constraints: const BoxConstraints(maxHeight: 36),
          color: Colors.grey[600],
          onPressed: () {
            setState(() {});
            widget.subtask.isDone = !widget.subtask.isDone;
            widget.task.save();
          },
        ),
        Text(
          widget.subtask.title,
          style: TextStyle(
            fontSize: 11,
            decoration: widget.subtask.isDone == true ? TextDecoration.lineThrough : TextDecoration.none,
            fontStyle: FontStyle.italic,
            overflow: TextOverflow.ellipsis,
            color: Colors.grey,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
