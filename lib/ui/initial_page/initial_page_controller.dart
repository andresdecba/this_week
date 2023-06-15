import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/data_source/hive_data_sorce/hive_data_source.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/app_config_model.dart';
import 'package:todoapp/models/subtask_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/initial_page/build_week_controller.dart';
import 'package:todoapp/ui/shared_components/create_task_bottomsheet.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';

class InitialPageController extends GetxController
    with WidgetsBindingObserver, BuildWeekController {
  //,OpenTaskController
  @override
  void onInit() async {
    super.onInit();
    initSampleTask();
    await initConfig();
    //calculateWeeksDifference();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    openTaskFromNotification();
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    pageCtlr.dispose();
  }

  // conocer el estado de la app NO USADO DE MOMENTO //
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // tutotial: https://stackoverflow.com/questions/51835039/how-do-i-check-if-the-flutter-application-is-in-the-foreground-or-not
    debugPrint("app state in values ${AppLifecycleState.values}");
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("app state in resumed");
        break;
      case AppLifecycleState.inactive:
        debugPrint("app state in inactive");
        break;
      case AppLifecycleState.paused:
        debugPrint("app state in paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("app state in detached");
        break;
    }
  }

  // box de tasks
  Box<TaskModel> tasksBox = Boxes.getTasksBox();
  RxBool simulateDeleting = false.obs;

  // INITIALIZE APP CONFIGURATIONS //
  AppConfigModel appConfig = AppConfigModel();
  Future<void> initConfig() async {
    appConfig = Boxes.getMyAppConfigBox().get('appConfig')!;
  }

  void openTaskFromNotification() async {
    // desde la notificacion con la app cerrada
    if (notificationPayload != null) {
      Rx<TaskModel> e = tasksBox.get(int.parse(notificationPayload!))!.obs;
      Get.put(ViewTaskController(task: e));
      createTaskBottomSheet(
        context: Get.context!,
        child: const ViewTask(),
      );
      notificationPayload = null;
    }
  }

  void simulateDeletingData() {
    simulateDeleting.value = true;
    Timer(const Duration(seconds: 1), () {
      simulateDeleting.value = false;
    });
  }

  void initSampleTask() {
    final tasksBox = Boxes.getTasksBox();

    if (config.createSampleTask && tasksBox.get(0) == null) {
      final DateTime today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        0,
        0,
        0,
      );
      var task = TaskModel(
        description: 'sample task description'.tr,
        taskDate: today,
        status: TaskStatus.PENDING.toStringValue,
        subTasks: [
          SubTaskModel(
              title: 'sample task  subtask_1 description'.tr, isDone: false),
          SubTaskModel(
              title: 'sample task  subtask_2 description'.tr, isDone: true),
        ],
        repeatId: null,
      );
      tasksBox.put(0, task);
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

  ///// SIDE BAR /////
  // CHANGE LANGUAGE DIALOG on drawer //
  List<Locale> langsCodes = [
    const Locale('en', ''),
    const Locale('es', ''),
    const Locale('pt', '')
  ];
  List<String> langs = ['English', 'Español', 'Português'];
  Rx<Locale> currentLang = (Get.locale!).obs;
  void saveLocale(String langCode) {
    //currentLang.value = data;
    //Get.updateLocale(data);
    appConfig.language = langCode;
    appConfig.save();
  }
}
