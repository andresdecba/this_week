import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/data_source/hive_data_sorce/hive_data_source.dart';
import 'package:todoapp/models/app_config_model.dart';
import 'package:todoapp/models/subtask_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:uuid/uuid.dart';

class InitialPageController extends GetxController with WidgetsBindingObserver {
  //,OpenTaskController
  @override
  void onInit() async {
    super.onInit();
    initSampleTask();
    await initConfig();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
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
  final uuid = const Uuid();

  // INITIALIZE APP CONFIGURATIONS //
  AppConfigModel appConfig = AppConfigModel();
  Future<void> initConfig() async {
    appConfig = Boxes.getMyAppConfigBox().get('appConfig')!;
  }

  void simulateDeletingData() {
    simulateDeleting.value = true;
    Timer(const Duration(seconds: 1), () {
      simulateDeleting.value = false;
    });
  }

  void initSampleTask() {
    final tasksBox = Boxes.getTasksBox();

    if (Globals.config.createSampleTask && tasksBox.get(0) == null) {
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
        id: uuid.v4(), // random id
        description: 'sample task description'.tr,
        date: today,
        status: TaskStatus.PENDING.toStringValue,
        subTasks: [
          SubTaskModel(title: 'sample task  subtask_1 description'.tr, isDone: false),
          SubTaskModel(title: 'sample task  subtask_2 description'.tr, isDone: true),
        ],
        repeatId: null,
      );
      tasksBox.put(0, task);
    }
  }

  // 1- cambio la pagina y la semana
  final PageController pageCtlr = PageController(initialPage: 1000, keepPage: true, viewportFraction: 1);

  Week onPageChange(int index) {
    Week week = Week.current();
    int initialIndex = pageCtlr.initialPage; //1000
    int goToWeek = index - initialIndex;
    // pagina 1000 == current week
    if (index == pageCtlr.initialPage) {
      week = Week.current();
    }
    // pagina 1001 == adelantar 1 semana desde la actual
    if (index > initialIndex) {
      week = Week.current().addWeeks(goToWeek);
    }
    // pagina 999 == retroceder 1 semana desde la actual
    if (index < initialIndex) {
      week = Week.current().subtractWeeks(goToWeek.abs());
    }
    return week;
  }

  void returnToCurrentWeek() {
    pageCtlr.animateToPage(
      pageCtlr.initialPage,
      duration: const Duration(microseconds: 500),
      curve: Curves.bounceIn,
    );
  }

  ///// SIDE BAR /////
  // CHANGE LANGUAGE DIALOG on drawer //
  List<Locale> langsCodes = [const Locale('en', ''), const Locale('es', ''), const Locale('pt', '')];
  List<String> langs = ['English', 'Español', 'Português'];
  Rx<Locale> currentLang = (Get.locale!).obs;
  void saveLocale(String langCode) {
    //currentLang.value = data;
    //Get.updateLocale(data);
    appConfig.language = langCode;
    appConfig.save();
  }
}
