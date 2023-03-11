import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/my_app_config.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/services/ad_mob_service.dart';
import 'package:todoapp/utils/helpers.dart';

class InitialPageController extends GetxController with AdMobService {
  // box de tasks
  Box<Task> tasksBox = Boxes.getTasksBox();

  // related to buil days an weeks
  int addWeeks = 0;
  List<DateTime> weekDays = [];
  Rx<Map<DateTime, List<Task>>> buildWeek = Rx<Map<DateTime, List<Task>>>({}); // Type: Map<DateTime, List<Task>>
  String initialFinalDays = '';

  // create strings for head
  Week showCurrenWeekInfo = Week.current();
  Rx<String> weekDaysFromTo = ''.obs;
  Rx<String> tasksPercentageCompleted = ''.obs;

  // others
  PageStorageKey keyScroll = const PageStorageKey<String>('home_page_scroll');
  RxBool simulateReloadPage = false.obs;

  // scaffold key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // CHANGE LANGUAGE DIALOG on drawer //
  List<Locale> langsCodes = [const Locale('en', ''), const Locale('es', ''), const Locale('pt', '')];
  List<String> langs = ['English', 'Español', 'Português'];
  Rx<Locale> currentLang = (Get.locale!).obs;
  void saveLocale(Locale data) {
    currentLang.value = data;
    //Get.updateLocale(data);
    appConfig.language = data.languageCode;
    appConfig.save();
  }

  // INITIALIZE APP CONFIGURATIONS //
  MyAppConfig appConfig = MyAppConfig();
  Future<void> initConfig() async {
    appConfig = Boxes.getMyAppConfigBox().get('appConfig')!;
  }

  @override
  void onInit() async {
    await initConfig();
    buildInfo();
    super.onInit();
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

  void buildInfo() {
    // limpiar lista para evitar duplicados
    weekDays.clear();
    buildWeek.value.clear();

    // crear los dias
    Week currentWeek = Week.current();

    if (addWeeks == 0) {
      weekDays = currentWeek.days;
      showCurrenWeekInfo = currentWeek;
    }
    if (addWeeks > 0) {
      currentWeek = currentWeek.addWeeks(addWeeks);
      weekDays = currentWeek.days;
      showCurrenWeekInfo = currentWeek;
    }

    // ordenar las tareas segun los dias
    for (var day in weekDays) {
      buildWeek.value.addAll({day: []});
    }

    for (var element in buildWeek.value.entries) {
      /// agregar la tarea
      for (var task in tasksBox.values) {
        if (task.taskDate == element.key) {
          element.value.add(task);
        }
      }
    }
    setInitialAndFinalWeekDays();
    createCompletedTasksPercentage();
    buildWeek.refresh();
  }

  /// create head info
  void setInitialAndFinalWeekDays() {
    var week = showCurrenWeekInfo.weekNumber.toString();
    var days = '${dayAndMonthFormater(showCurrenWeekInfo.days.first)} ${'to'.tr} ${dayAndMonthFormater(showCurrenWeekInfo.days.last)}';
    //var days = '${Utils.dateToAbbreviateString(showCurrenWeekInfo.days.first)} ${'to'.tr} ${Utils.dateToAbbreviateString(showCurrenWeekInfo.days.last)}';
    weekDaysFromTo.value = '${'week'.tr} $week: $days';
  }

  void createCompletedTasksPercentage() {
    int totalTasks = 0;
    int completedTotalTasks = 0;
    int completedTasksPercent = 0;

    for (List value in buildWeek.value.values) {
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
    if (taskKey != null) {
      Map<String, String> data = {
        "taskId": taskKey.toString(),
      };
      Get.offAllNamed(Routes.FORMS_PAGE, parameters: data);
      //Get.delete<InitialPageController>();
      return;
    }
    if (date != null) {
      Map<String, String> data = {
        "date": date.toString(),
      };
      Get.offAllNamed(Routes.FORMS_PAGE, parameters: data);
      //Get.delete<InitialPageController>();
      return;
    }
    Get.offAllNamed(Routes.FORMS_PAGE);
    //Get.delete<InitialPageController>();
  }

  ////// manage GOOGLE ADS //////
  ///
  late BannerAd myBanner;
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

    myBanner = BannerAd(
      adUnitId: AdMobService.banner_TEST!,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isAdLoaded.value = true;
          print('**ad ok!** $ad');
        },
        onAdFailedToLoad: (ad, error) {
          isAdLoaded.value = true;
          ad.dispose();
          print('**ad error** $error');
        },
      ),
    );
    myBanner.load();
  }
}
