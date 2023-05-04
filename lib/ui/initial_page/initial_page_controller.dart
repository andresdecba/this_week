import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/my_app_config.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/services/ad_mob_service.dart';
import 'package:todoapp/utils/helpers.dart';

class InitialPageController extends GetxController with AdMobService {
  // box de tasks
  Box<Task> tasksBox = Boxes.getTasksBox();

  // create strings for head
  //Week showCurrenWeekInfo = Week.current();
  Rx<String> weekDaysFromTo = ''.obs;
  Rx<String> tasksPercentageCompleted = ''.obs;

  // others
  PageStorageKey keyScroll = const PageStorageKey<String>('home_page_scroll');
  RxBool simulateDeleting = false.obs;

  // scaffold key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

  // INITIALIZE APP CONFIGURATIONS //
  MyAppConfig appConfig = MyAppConfig();
  Future<void> initConfig() async {
    appConfig = Boxes.getMyAppConfigBox().get('appConfig')!;
  }

  @override
  void onInit() async {
    initSampleTask();
    await initConfig();
    buildInfo();
    calculateWeeksDifference();
    super.onInit();
  }

  @override
  void onClose() {
    bannerAd.dispose();
    super.onClose();
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
      var task = Task(
        description: 'sample task description'.tr,
        taskDate: today,
        notificationTime: null,
        status: TaskStatus.PENDING.toValue,
        subTasks: [
          SubTask(title: 'sample task  subtask_1 description'.tr, isDone: false),
          SubTask(title: 'sample task  subtask_2 description'.tr, isDone: true),
        ],
        notificationId: null,
        repeatId: null,
      );
      tasksBox.put(0, task);
    }
  }

  /// ejemplo del modelo de datos
  //Map<DateTime, List<Task>> buildWeekDemo = {
  //  'Lunes 26-11-2022'    : ['task_1', 'task_2'],
  //  'Martes 27-11-2022'   : ['task_1', 'task_2'],
  //  'Miercoles 28-11-2022': [],
  //  'Jueves 29-11-2022'   : ['task_1'],
  //  'Viernes 30-11-2022'  : ['task_1', 'task_2'],
  //  'Sabado 01-12-2022'   : [],
  //  'Domingo 02-12-2022'  : [],
  //};

  // related to buil days an weeks
  late int oldWeeks = 0;
  late int increaseDecreaseWeeks;
  Week week = Week.current();
  Rx<Map<DateTime, List<Task>>> buildWeekInUI = Rx<Map<DateTime, List<Task>>>({});

  void increaseWeek() {
    week = week.next;
    // if (increaseDecreaseWeeks < oldWeeks) {
    //   increaseDecreaseWeeks++;
    // }
    increaseDecreaseWeeks++;
    print('averga increase $increaseDecreaseWeeks');
    buildInfo();
  }

  void decreaseWeek() {
    if (increaseDecreaseWeeks > 0) {
      week = week.previous;
      increaseDecreaseWeeks--;
    }
    print('averga decrease $increaseDecreaseWeeks');
    buildInfo();
  }

  void calculateWeeksDifference() {
    if (tasksBox.isNotEmpty) {
      var firstTaskWeek = Week.fromDate(tasksBox.values.first.taskDate);
      var currentWeek = Week.current();
      oldWeeks = currentWeek.weekNumber - firstTaskWeek.weekNumber;
      increaseDecreaseWeeks = oldWeeks;
    }
    print('averga increaseDecreaseWeeks $increaseDecreaseWeeks / oldWeeks $oldWeeks');
  }

  void buildInfo() {
    // limpiar lista para evitar duplicados
    buildWeekInUI.value.clear();

    // agregar el dia como key al mapa de la semana
    // ej: 20/03/2023: []
    for (var day in week.days) {
      buildWeekInUI.value.addAll({day: []});
    }

    // si hay tareas guardadas, agregarlas al dia correspondinete
    // ej: 20/03/2023: [Task_1{}, task_2{}]
    for (var element in buildWeekInUI.value.entries) {
      for (var task in tasksBox.values) {
        if (task.taskDate == element.key) {
          element.value.add(task);
        }
      }
    }
    setInitialAndFinalWeekDays();
    createCompletedTasksPercentage();
    buildWeekInUI.refresh();
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

    for (List value in buildWeekInUI.value.values) {
      totalTasks += value.length;
      for (var element in value) {
        if (element.status == TaskStatus.DONE.toValue) {
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

  /// navegar para crear o editar
  void navigate({int? taskKey, DateTime? date}) {

    // si quiere abrir una tarea
    if (taskKey != null) {
      Map<String, String> data = {
        "taskId": taskKey.toString(),
      };
      Get.offAllNamed(Routes.FORMS_PAGE, arguments: data);
      return;
    }
    // si quiere crear una tarea a partir de una fecha en particular
    if (date != null) {
      Map<String, String> data = {
        "date": date.toString(),
      };
      Get.offAllNamed(Routes.FORMS_PAGE, arguments: data);
      return;
    }
    // si quiere crear una tarea a partir de nada
    Get.offAllNamed(Routes.FORMS_PAGE);
  }

  ////// manage GOOGLE ADS //////

  late BannerAd bannerAd;
  RxBool isAdLoaded = false.obs;

  /// onReady() Called 1 frame after onInit(). It is the perfect place to enter
  /// navigation events, like snackbar, dialogs, or a new route, or async request.
  @override
  void onReady() {
    initSmartBannerAd();
    super.onReady();
  }

  void initSmartBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(Get.context!).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    bannerAd = BannerAd(
      adUnitId: AdMobService.testBanner!,
      //adUnitId: AdMobService.initialPageBanner!,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isAdLoaded.value = true;
          print('INITIAL page banner: responseId = ${ad.responseInfo!.responseId} / adId = ${ad.adUnitId}');
        },
        onAdFailedToLoad: (ad, error) {
          isAdLoaded.value = true;
          ad.dispose();
          print('**banner_1 error** $error');
        },
      ),
    );
    bannerAd.load();
  }
}
