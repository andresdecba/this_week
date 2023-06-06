import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/models/task_model.dart';

// global para poder acceder desde los use cases
late CreateWeekObs createWeekObs;

mixin BuildWeekController {
  //
  /// GENERATE LIST OF TASKS FOR THIS WEEK
  RxList<Rx<TaskModel>> getWeekTasks({required Week week, required Box<TaskModel> tasksBox}) {
    // vars
    RxList<Rx<TaskModel>> _createWeekObs = RxList<Rx<TaskModel>>([]);
    var firstDay = week.days.first.subtract(const Duration(days: 1));
    var lastDay = week.days.last.add(const Duration(days: 1));

    List<TaskModel> result = tasksBox.values.where((task) {
      return task.taskDate.isAfter(firstDay) && task.taskDate.isBefore(lastDay);
    }).toList();

    for (var element in result) {
      Rx<TaskModel> taskObs = element.obs;
      _createWeekObs.add(taskObs);
    }

    createWeekObs = CreateWeekObs(tasks: _createWeekObs);
    generateStatistics();
    return _createWeekObs;
  }

  /// CHANGE THE PAGE
  final PageController pageCtlr = PageController(initialPage: 1000);
  Rx<Week> week = Week.current().obs;
  int oldIndex = 1000;

  void changePage(int index) {
    if (index == pageCtlr.initialPage) {
      week.value = Week.current();
      oldIndex = index;
      debugPrint('holis initial $index');
      return;
    }
    if (index > oldIndex) {
      week.value = week.value.next;
      oldIndex = index;
      debugPrint('holis derecha $index');
    }
    if (index < oldIndex) {
      week.value = week.value.previous;
      oldIndex = index;
      debugPrint('holis izquierda $index');
    }
  }

  void returnToCurrentWeek() {
    pageCtlr.animateToPage(
      pageCtlr.initialPage,
      duration: const Duration(microseconds: 500),
      curve: Curves.bounceIn,
    );
  }

  /// CALCULATE PERCENTAGES
  Rx<int> done = 0.obs;
  Rx<int> inProgress = 0.obs;
  Rx<int> pending = 0.obs;

  void generateStatistics() {
    int totalTasks = createWeekObs.tasks.length;
    int totalDone = 0;
    int totalInProgress = 0;
    int totalPending = 0;

    for (var e in createWeekObs.tasks) {
      if (e.value.status == TaskStatus.DONE.toStringValue) {
        totalDone += 1;
      }
      if (e.value.status == TaskStatus.IN_PROGRESS.toStringValue) {
        totalInProgress += 1;
      }
      if (e.value.status == TaskStatus.PENDING.toStringValue) {
        totalPending += 1;
      }
    }

    if (totalTasks != 0) {
      done.value = ((totalDone / totalTasks) * 100).toInt();
      inProgress.value = ((totalInProgress / totalTasks) * 100).toInt();
      pending.value = ((totalPending / totalTasks) * 100).toInt();
    }
  }
}

class CreateWeekObs {
  CreateWeekObs({
    required this.tasks,
  });

  final RxList<Rx<TaskModel>> tasks;

  CreateWeekObs copyWith({required RxList<Rx<TaskModel>> tasks}) {
    return CreateWeekObs(tasks: tasks);
  }
}
