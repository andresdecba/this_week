import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';
import 'package:intl/intl.dart';

// drag handle
// ReorderableDragStartListener(
//   index: index,
//   child: const Icon(Icons.drag_handle),
// )

class TaskCardWidget extends StatefulWidget {
  const TaskCardWidget({
    required this.tarea,
    required this.index,
    Key? key,
  }) : super(key: key);

  final Task tarea;
  final int index;

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
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
            maintainState: true,
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            textColor: Colors.black,
            childrenPadding: const EdgeInsets.symmetric(horizontal: 26),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: Row(
              children: [
                ReorderableDelayedDragStartListener(
                  index: widget.index,
                  child: Icon(
                    Icons.reorder,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ),
                Text(
                  '  ${widget.tarea.title}',
                  style: const TextStyle(),
                ),
              ],
            ),
            subtitle: Text(
              '10:00 - 13:00 hs.  ${DateFormat('MM-dd-yy').format(widget.tarea.dateTime)}',
              style: TextStyle(color: Colors.grey[300], fontSize: 12),
            ),
            children: [
              /// descripcion de la tarea
              widget.tarea.description == ''
                  ? const SizedBox()
                  : Wrap(children: [
                      Text(
                        widget.tarea.description,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                    ]),

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
                      return ToggleButton(
                        task: widget.tarea,
                        onTap: () => setStatusColor(),
                      );
                    }),
                  ),
                  Wrap(
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.tarea.delete();
                          _controller.dataList.removeAt(widget.index);
                        },
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

/// status buttons
class ToggleButton extends StatefulWidget {
  const ToggleButton({
    required this.task,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Task task;
  final VoidCallback onTap;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  List<bool> isSelected = <bool>[];
  int _index = 0;

  @override
  void initState() {
    if (widget.task.status == TaskStatus.PENDING.toValue) {
      isSelected = [true, false, false];
    }
    if (widget.task.status == TaskStatus.IN_PROGRESS.toValue) {
      isSelected = [false, true, false];
    }
    if (widget.task.status == TaskStatus.DONE.toValue) {
      isSelected = [false, false, true];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (int index) {
        setState(() {});
        for (int i = 0; i < isSelected.length; i++) {
          isSelected[i] = i == index;
        }
        switch (index) {
          case 0:
            widget.task.status = TaskStatus.PENDING.toValue;
            _index = index;
            break;
          case 1:
            widget.task.status = TaskStatus.IN_PROGRESS.toValue;
            _index = index;
            break;
          case 2:
            widget.task.status = TaskStatus.DONE.toValue;
            _index = index;
            break;
        }
        widget.task.save();
        widget.onTap();

        /// set status color
      },
      isSelected: isSelected,
      borderColor: Colors.white,
      borderWidth: 0,
      constraints: const BoxConstraints.tightForFinite(height: double.infinity, width: double.infinity),
      renderBorder: false,
      fillColor: Colors.white,
      selectedColor: Colors.green,
      //color: Colors.grey,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            'Pending',
            style: TextStyle(fontSize: 11, color: widget.task.status == TaskStatus.PENDING.toValue ? Colors.black : Colors.grey[400]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            'In progress',
            style: TextStyle(fontSize: 11, color: widget.task.status == TaskStatus.IN_PROGRESS.toValue ? Colors.green : Colors.grey[400]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            'Done',
            style: TextStyle(fontSize: 11, color: widget.task.status == TaskStatus.DONE.toValue ? Colors.orange : Colors.grey[400]),
          ),
        ),
      ],
    );
  }
}
