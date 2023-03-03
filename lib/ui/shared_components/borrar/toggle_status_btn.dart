import 'package:flutter/material.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';

/// status buttons
class ToggleStatusButton extends StatefulWidget {
  const ToggleStatusButton({
    required this.task,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final Task task;
  final VoidCallback onChanged;

  @override
  State<ToggleStatusButton> createState() => _ToggleStatusButtonState();
}

class _ToggleStatusButtonState extends State<ToggleStatusButton> {
  List<bool> isSelected = <bool>[];

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
            break;
          case 1:
            widget.task.status = TaskStatus.IN_PROGRESS.toValue;
            break;
          case 2:
            widget.task.status = TaskStatus.DONE.toValue;
            break;
        }
        //widget.task.save();
        widget.onChanged();
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
            style: TextStyle(
              fontSize: 16,
              color: widget.task.status == TaskStatus.PENDING.toValue ? Colors.black : bdisabledColorLightO,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            'In progress',
            style: TextStyle(
              fontSize: 16,
              color: widget.task.status == TaskStatus.IN_PROGRESS.toValue ? Colors.green : bdisabledColorLightO,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            'Done',
            style: TextStyle(
              fontSize: 16,
              color: widget.task.status == TaskStatus.DONE.toValue ? Colors.orange : bdisabledColorLightO,
            ),
          ),
        ),
      ],
    );
  }
}
