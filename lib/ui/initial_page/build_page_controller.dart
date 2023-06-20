import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/data_source/hive_data_sorce/hive_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/utils/helpers.dart';

// global para poder acceder desde los use cases
///// BOOOORARRR ESTOO //////
final RxList<Rx<TaskModel>> createWeekObsGlobal = RxList<Rx<TaskModel>>([]);

class BuildPageController extends GetxController {
  //
  @override
  void onReady() {
    super.onReady();
    // mostrar tarea si entró una notificación cuando la app estaba cerrada
    if (Globals.closedAppPayload != null) {
      openAnyTask(Globals.closedAppPayload!);
    }
  }

  // box de tasks
  Box<TaskModel> tasksBox = Boxes.getTasksBox();

  // build //
  RxList<Rx<TaskModel>> buildTasks({required Box<TaskModel> tasksBox, required Week week}) {
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

    //createWeekObsGlobal = createWeekObs;
    //generateStatistics();
    return createWeekObs;
  }

  /// CALCULATE PERCENTAGES
  Rx<int> done = 0.obs;
  Rx<int> inProgress = 0.obs;
  Rx<int> pending = 0.obs;

  void generateStatistics() {
    int totalTasks = createWeekObsGlobal.length;
    int totalDone = 0;
    int totalInProgress = 0;
    int totalPending = 0;

    for (var e in createWeekObsGlobal) {
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

  String changeTaskStatus(String value) {
    switch (value) {
      case 'Pending':
        return TaskStatus.IN_PROGRESS.toStringValue;
      case 'In progress':
        return TaskStatus.DONE.toStringValue;
      case 'Done':
        return TaskStatus.PENDING.toStringValue;
      default:
        return TaskStatus.IN_PROGRESS.toStringValue;
    }
  }
}
