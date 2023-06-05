import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/models/task_model.dart';

//RxList<Rx<TaskModel>> createWeekObs = RxList<Rx<TaskModel>>([]);

mixin CreateWeekController {
  /// generate list of tasks for this week
  RxList<Rx<TaskModel>> getWeekTasks({required Week week, required Box<TaskModel> tasksBox}) {
    //--
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

    return _createWeekObs;
  }

  /// change page
  Week week = Week.current();
  int oldIndex = 1000;
  void changePage(int index) {
    if (index > oldIndex) {
      week = week.next;
      oldIndex = index;
      //buildInfo();
      debugPrint('holis derecha');
    }
    if (index < oldIndex) {
      week = week.previous;
      oldIndex = index;
      //buildInfo();
      debugPrint('holis izquierda');
    }
  }
}
