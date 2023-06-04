import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/data_source/hive_data_sorce/hive_data_source.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/app_config_model.dart';
import 'package:todoapp/models/subtask_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/core/services/ad_mob_service.dart';
import 'package:todoapp/ui/shared_components/my_modal_bottom_sheet.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';
import 'package:todoapp/utils/helpers.dart';

class InitialPageController extends GetxController with AdMobService, StateMixin<dynamic>, WidgetsBindingObserver {
  //,OpenTaskController
  @override
  void onInit() async {
    super.onInit();
    initSampleTask();
    await initConfig();
    buildInfo();
    //calculateWeeksDifference();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    loadBannerAd(bannerListener: initialPageBannerListener()); // de prueba
    //loadBannerAd(bannerListener: initialPageBannerListener(), adUnitId: AdMobService.initialPageBanner!); //publicidad posta
    openTaskFromNotification();
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
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

  // create strings for head
  //Week showCurrenWeekInfo = Week.current();
  Rx<String> weekDaysFromTo = ''.obs;
  Rx<String> tasksPercentageCompleted = ''.obs;

  // others
  PageStorageKey keyScroll = const PageStorageKey<String>('home_page_scroll');
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
      myModalBottomSheet(
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
          SubTaskModel(title: 'sample task  subtask_1 description'.tr, isDone: false),
          SubTaskModel(title: 'sample task  subtask_2 description'.tr, isDone: true),
        ],
        repeatId: null,
      );
      tasksBox.put(0, task);
    }
  }

  /// ejemplo del modelo de datos
  //Map<DateTime, List<Task>> tasksMap = {
  //  '2023-05-29 00:00:00.000': ['task_1', 'task_2'],
  //  '2023-05-30 00:00:00.000': ['task_1', 'task_2'],
  //  '2023-05-31 00:00:00.000': [],
  //  '2023-06-03 00:00:00.000': ['task_1'],
  //  '2023-06-04 00:00:00.000': ['task_1', 'task_2'],
  //};

  /// asi se guarga en hive
  //1: { description: Nueva tarea martes, task date: 2023-05-30 00:00:00.000, status: Pending, sub tasks: [], repeat Id: null, notification data: null },
  //2: { description: Nueva tarea Miercoles, task date: 2023-05-31 00:00:00.000, status: Pending, sub tasks: [], repeat Id: null, notification data: null },

  // related to buil days an weeks
  // final PageController pageController = PageController(initialPage: 1000);
  // late int oldWeeks = 0;
  // late int increaseDecreaseWeeks;
  // Week week = Week.current();
  // RxMap<DateTime, List<Rx<TaskModel>>> tasksMap = RxMap<DateTime, List<Rx<TaskModel>>>({});

  // void increaseWeek() {
  //   week = week.next;
  //   increaseDecreaseWeeks++;
  //   buildInfo();
  // }

  // void decreaseWeek() {
  //   if (increaseDecreaseWeeks > 0) {
  //     week = week.previous;
  //     increaseDecreaseWeeks--;
  //   }
  //   buildInfo();
  // }

  // void calculateWeeksDifference() {
  //   if (tasksBox.isNotEmpty) {
  //     var firstTaskWeek = Week.fromDate(tasksBox.values.first.taskDate);
  //     var currentWeek = Week.current();
  //     oldWeeks = currentWeek.weekNumber - firstTaskWeek.weekNumber;
  //     increaseDecreaseWeeks = oldWeeks;
  //   }
  // }

  final PageController pageController = PageController(initialPage: 1000);
  RxMap<DateTime, List<Rx<TaskModel>>> tasksMap = RxMap<DateTime, List<Rx<TaskModel>>>({});
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

  RxMap<DateTime, List<Rx<TaskModel>>> buildInfo() {
    print('hola current week ${Week.current()}');
    print('hola this misma week $week');

    RxMap<DateTime, List<Rx<TaskModel>>> tasksMapita = RxMap<DateTime, List<Rx<TaskModel>>>({});

    // limpiar lista para evitar duplicados
    tasksMapita.clear();
    // agregar el dia como key al mapa de la semana
    // ej: tasksMap = {20/03/2023: []}
    for (var day in week.days) {
      tasksMapita.addAll({day: []});
    }
    // si hay tareas guardadas, agregarlas al dia correspondinete
    // ej: tasksMap = {20/03/2023: [Task_1{}, task_2{}]}
    for (var element in tasksMapita.entries) {
      for (var task in tasksBox.values) {
        if (task.taskDate == element.key) {
          Rx<TaskModel> taskObs = task.obs;
          element.value.add(taskObs);
        }
      }
    }
    //setInitialAndFinalWeekDays();
    //createCompletedTasksPercentage();
    tasksMapita.refresh();
    return tasksMapita;
  }

  /// create head info
  void setInitialAndFinalWeekDays() {
    var days = '${dayAndMonthFormater(week.days.first)} ${'to'.tr} ${dayAndMonthFormater(week.days.last)}';
    weekDaysFromTo.value = week == Week.current() ? '${'current week'.tr} $days' : '${'week'.tr} ${week.weekNumber}: $days';
  }

  void createCompletedTasksPercentage() {
    int totalTasks = 0;
    int completedTotalTasks = 0;
    int completedTasksPercent = 0;

    for (List value in tasksMap.values) {
      totalTasks += value.length;
      for (var element in value) {
        if (element.value.status == TaskStatus.DONE.toStringValue) {
          completedTotalTasks += 1;
        }
      }
    }
    if (totalTasks != 0) {
      completedTasksPercent = ((completedTotalTasks / totalTasks) * 100).toInt();
    }
    // set message
    totalTasks == 0 ? tasksPercentageCompleted.value = 'no tasks for this week'.tr : tasksPercentageCompleted.value = '$completedTasksPercent% ${'of completed tasks'.tr}';
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
  List<Locale> langsCodes = [const Locale('en', ''), const Locale('es', ''), const Locale('pt', '')];
  List<String> langs = ['English', 'Español', 'Português'];
  Rx<Locale> currentLang = (Get.locale!).obs;
  void saveLocale(String langCode) {
    //currentLang.value = data;
    //Get.updateLocale(data);
    appConfig.language = langCode;
    appConfig.save();
  }

  ///// LOAD GOOGLE AD /////
  BannerAdListener initialPageBannerListener() {
    change(Null, status: RxStatus.loading());
    return BannerAdListener(
      onAdLoaded: (Ad ad) {
        change(ad, status: RxStatus.success());
      },
      onAdFailedToLoad: (Ad ad, LoadAdError adError) {
        change(null, status: RxStatus.error('failed to load AD'.tr));
        ad.dispose();
      },
    );
  }
}
