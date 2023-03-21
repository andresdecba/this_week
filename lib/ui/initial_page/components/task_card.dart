import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/utils/helpers.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    required this.task,
    required this.navigate,
    required this.onStatusChange,
    required Key key,
    this.isDisabled,
  }) : super(key: key);

  final Task task;
  final VoidCallback navigate;
  final VoidCallback onStatusChange;
  final bool? isDisabled;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        //padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              color: setStatusColor(),
              width: 4,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// task DESCRIPTION
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
              child: Text(
                widget.task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: setStatusTextStyle(),
              ),
            ),
            //const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// task STATUS
                  Flexible(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () {
                        widget.onStatusChange();
                        setState(() {});
                      },
                      child: Text(
                        setStatusLanguage(),
                        style: kLabelLarge.copyWith(color: setStatusColor()),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Row(
                      //crossAxisAlignment: WrapCrossAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// task NOTIFICATION TIME
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(
                              widget.task.notificationTime != null ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                              size: 20,
                              color: widget.task.notificationTime != null ? enabled_grey : disabled_grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.task.notificationTime != null ? timeFormater(widget.task.notificationTime!) : '-- : --', // TODO
                              style: kLabelMedium.copyWith(color: widget.task.notificationTime != null ? enabled_grey : disabled_grey),
                            ),
                          ],
                        ),
                        //const SizedBox(width: 8),

                        /// task SUBTASKS
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(
                              Icons.checklist_rounded,
                              size: 20,
                              color: widget.task.subTasks.isEmpty ? disabled_grey : enabled_grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              calculateSubtasksDone(),
                              style: kLabelMedium.copyWith(color: widget.task.subTasks.isEmpty ? disabled_grey : enabled_grey),
                            ),
                          ],
                        ),
                        //const SizedBox(width: 32),

                        /// task NAVIGATE
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => widget.navigate(),
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                          ),
                        ),
                        //const SizedBox(width: 12),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String calculateSubtasksDone() {
    int value = 0;
    for (var i = 0; i < widget.task.subTasks.length; i++) {
      if (widget.task.subTasks[i].isDone) {
        value++;
      }
    }
    return '$value of ${widget.task.subTasks.length}';
  }

  String setStatusLanguage() {
    switch (widget.task.status) {
      case 'Pending':
        return 'pending'.tr;
      case 'In progress':
        return 'in progress'.tr;
      case 'Done':
        return 'done'.tr;
      default:
        return 'pending'.tr;
    }
  }

  Color setStatusColor() {
    switch (widget.task.status) {
      case 'Pending':
        return status_task_pending;
      case 'In progress':
        return status_task_in_progress;
      case 'Done':
        return status_task_done;
      default:
        return status_task_pending;
    }
  }

  TextStyle setStatusTextStyle() {
    switch (widget.task.status) {
      case 'Pending':
        return kBodyMedium;
      case 'In progress':
        return kBodyMedium;
      case 'Done':
        return kBodyMedium.copyWith(fontStyle: FontStyle.italic, decoration: TextDecoration.lineThrough, color: disabled_grey);
      default:
        return kBodyMedium;
    }
  }
}
