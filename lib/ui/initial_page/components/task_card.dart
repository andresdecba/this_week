import 'package:flutter/material.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/utils/helpers.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    required this.task,
    required this.navigate,
    required this.onStatusChange,
    required this.isToday,
    this.isDisabled,
    required Key key,
  }) : super(key: key);

  final TaskModel task;
  final VoidCallback navigate;
  final VoidCallback onStatusChange;
  final bool? isDisabled;
  final bool isToday;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => widget.navigate(),
          child: Container(
            //padding: const EdgeInsets.all(16),
            //padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.isToday ? bluePrimary : Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              // boxShadow: [
              //   BoxShadow(
              //     color: disabledGrey.withOpacity(0.5),
              //     offset: Offset(1, 1), //(x,y)
              //     blurRadius: 4,
              //   ),
              // ],
              // border: Border(
              //   top: BorderSide(
              //     color: disabledGrey, //setStatusColor(widget.task),
              //     width: 1,
              //   ),
              //   right: BorderSide(
              //     color: disabledGrey, //setStatusColor(widget.task),
              //     width: 1,
              //   ),
              //   bottom: BorderSide(
              //     color: disabledGrey, //setStatusColor(widget.task),
              //     width: 1,
              //   ),
              //   left: BorderSide(
              //     color: disabledGrey, //setStatusColor(widget.task),
              //     width: 1,
              //   ),
              // ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// task DESCRIPTION
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // TEXTO DESCRIPCION
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          widget.task.description,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: setStatusTextStyle(widget.task, widget.isToday),
                        ),
                      ),
                    ),

                    /// task SUBTASKS
                    Visibility(
                      visible: widget.task.subTasks.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(Icons.checklist_rounded, size: 14, color: widget.isToday ? whiteBg.withOpacity(0.6) : disabledGrey),
                      ),
                    ),

                    // IS ROUTINE
                    Visibility(
                      visible: widget.task.repeatId != null,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.push_pin_rounded,
                          size: 14,
                          color: widget.isToday ? whiteBg.withOpacity(0.6) : enabledGrey,
                        ),
                      ),
                    ),

                    // BUTTTON STATUS
                    IconButton(
                      onPressed: () {
                        widget.onStatusChange();
                        setState(() {});
                      },
                      icon: setStatusIcon(widget.task, widget.isToday),
                      padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
                      visualDensity: VisualDensity.compact,
                      iconSize: 16,
                    )
                  ],
                ),
                //const SizedBox(height: 10),

                /// task SUBTASKS
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Icon(
                //       Icons.checklist_rounded,
                //       size: 20,
                //       color: widget.isToday ? blackBg : disabledGrey,
                //     ),
                //     const SizedBox(width: 8),
                //     Text(
                //       calculateSubtasksDone(),
                //       style: kLabelMedium.copyWith(
                //         color: widget.isToday ? blackBg : disabledGrey,
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
        // Positioned.fill(
        //   child: Align(
        //     alignment: Alignment.bottomRight,
        //     child: Padding(
        //       padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        //       child: GestureDetector(
        //         onTap: () {
        //           widget.onStatusChange();
        //           setState(() {});
        //         },
        //         child: Text(
        //           setStatusLanguage(widget.task),
        //           style: kLabelMedium.copyWith(color: widget.isToday ? blackBg : disabledGrey, fontStyle: FontStyle.italic), //setStatusColor(widget.task)
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
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
}


  // Positioned.fill(
        //   child: Align(
        //     alignment: Alignment.bottomRight,
        //     child: Padding(
        //       padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        //       child: GestureDetector(
        //         onTap: () {
        //           widget.onStatusChange();
        //           setState(() {});
        //         },
        //         child: Text(
        //           setStatusLanguage(widget.task),
        //           style: kLabelMedium.copyWith(color: widget.isToday ? blackBg : disabledGrey, fontStyle: FontStyle.italic), //setStatusColor(widget.task)
        //         ),
        //       ),
        //     ),
        //   ),
        // ),