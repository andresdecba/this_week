import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/models/task_model.dart';

// global para poder acceder desde los use cases
late CreateWeekObs createWeekObsGlobal;

mixin BuildWeekController {
  //
  /// GENERATE LIST OF TASKS FOR THIS WEEK
  Future<RxList<Rx<TaskModel>>> getWeekTasks({required Week week, required Box<TaskModel> tasksBox}) async {
    // vars
    RxList<Rx<TaskModel>> createWeekObs = RxList<Rx<TaskModel>>([]);
    var firstDay = week.days.first.subtract(const Duration(days: 1));
    var lastDay = week.days.last.add(const Duration(days: 1));
    List<TaskModel> result = [];

    await Future.microtask(() {
      result = tasksBox.values.where((task) {
        return task.date.isAfter(firstDay) && task.date.isBefore(lastDay);
      }).toList();
    });

    await Future.microtask(() {
      for (var element in result) {
        Rx<TaskModel> taskObs = element.obs;
        createWeekObs.add(taskObs);
      }
    });

    // teóricamente los microtasks deberian esperar pero pareceque no anda ó
    // pasa muy rápido asi que puse un timer.
    await Future.delayed(const Duration(milliseconds: 400));
    createWeekObsGlobal = CreateWeekObs(tasks: createWeekObs);

    await Future.microtask(() {
      generateStatistics();
    });
    return createWeekObs;
  }

  RxList<Rx<TaskModel>> getWeekTasksDos({required Week week, required Box<TaskModel> tasksBox}) {
    // vars
    RxList<Rx<TaskModel>> createWeekObs = RxList<Rx<TaskModel>>([]);
    var firstDay = week.days.first.subtract(const Duration(days: 1));
    var lastDay = week.days.last.add(const Duration(days: 1));
    List<TaskModel> result = [];

    result = tasksBox.values.where((task) {
      return task.date.isAfter(firstDay) && task.date.isBefore(lastDay);
    }).toList();

    for (var element in result) {
      Rx<TaskModel> taskObs = element.obs;
      createWeekObs.add(taskObs);
    }

    createWeekObsGlobal = CreateWeekObs(tasks: createWeekObs);

    generateStatistics();

    return createWeekObs;
  }

  /// CHANGE THE PAGE
  final PageController pageCtlr = PageController(initialPage: 1000, keepPage: true, viewportFraction: 1);

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
    int totalTasks = createWeekObsGlobal.tasks.length;
    int totalDone = 0;
    int totalInProgress = 0;
    int totalPending = 0;

    for (var e in createWeekObsGlobal.tasks) {
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
