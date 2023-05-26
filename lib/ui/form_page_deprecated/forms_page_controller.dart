// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:todoapp/core/routes/routes.dart';
// import 'package:todoapp/data_source/db_data_source.dart';
// import 'package:todoapp/main.dart';
// import 'package:todoapp/models/app_config_model.dart';
// import 'package:todoapp/models/notification_model.dart';
// import 'package:todoapp/models/task_model.dart';
// import 'package:todoapp/services/local_notifications_service.dart';
// import 'package:todoapp/ui/commons/styles.dart';
// import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
// import 'package:todoapp/ui/shared_components/dialogs.dart';
// import 'package:todoapp/ui/shared_components/snackbar.dart';
// import 'package:todoapp/utils/helpers.dart';

import 'package:get/get.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';
import 'package:todoapp/services/ad_mob_service.dart';

enum PageMode { VIEW_MODE, UPDATE_MODE, NEW_MODE }

class FormsPageController extends GetxController with AdMobService, StateMixin<dynamic> {

  FormsPageController({
    required this.notificationsUseCases,
  });
  final NotificationsUseCases notificationsUseCases;

  /*

  //
  @override
  void onInit() {
    setInitialConfig();
    setPageModesHelper();
    enableDisableNotificationStyles();
    hasUserInteractionInit();
    super.onInit();
  }

  @override
  void onReady() {
    loadBannerAd(bannerListener: initialPageBannerListener());
    //loadBannerAd(bannerListener: initialPageBannerListener(), adUnitId: AdMobService.formPageBanner!);
    super.onReady();
  }

  @override
  void onClose() {
    taskDescriptionCtrlr.dispose();
    subTaskTitleCtrlr.dispose();
    super.onClose();
  }

  ///// NOTIFICATIONS /////
  final NotificationsUseCases notificationsUseCases;

  ////// manage HIVE //////
  final tasksBox = Boxes.getTasksBox();

  ////// manage APP CONFIG //////
  final userPrefs = Boxes.getMyAppConfigBox();

  ////// manage INITIAL PAGE ACTIVITY //////
  TaskModel get getTask => _task.value;
  final Rx<TaskModel> _task = TaskModel(
    description: '',
    taskDate: DateTime.now(),
    notificationTime: null,
    status: TaskStatus.PENDING.toValue,
    subTasks: [],
    notificationId: null,
    repeatId: null,
  ).obs;

  void llenarInfo(int value) {
    _task.value = tasksBox.get(value)!;
    taskDescriptionCtrlr.text = _task.value.description;
    taskDate = _task.value.taskDate.obs;
    currentPageMode.value = PageMode.VIEW_MODE;
    initialTaskValues = _task.value.copyWith(
      description: _task.value.description,
      taskDate: _task.value.taskDate,
      notificationTime: _task.value.notificationTime,
      status: _task.value.status,
      subTasks: _task.value.subTasks,
      notificationId: _task.value.notificationId,
      repeatId: _task.value.repeatId,
    );
  }

  // Cuando refactoricemos, hacer algo mas pro con el tema de los argumentos
  void setInitialConfig() {
    // desde la notificacion con la app cerrada
    if (notificationPayload != null) {
      llenarInfo(int.parse(notificationPayload!));
      return;
    }

    // desde la notificación con la app abierta o en segundo plano
    if (Get.arguments['notificationPAYLOAD'] != null) {
      llenarInfo(int.parse(Get.arguments['notificationPAYLOAD']!));
      return;
    }

    // desde la pagina de inicio al abrir una tarea existente
    if (Get.arguments['taskId'] != null) {
      llenarInfo(int.parse(Get.arguments['taskId']!));
      return;
    }

    // desde la pagina de inicio al crear nueva tarea en una fecha especifica
    if (Get.arguments['date'] != null) {
      var arguments = DateTime.parse(Get.arguments['date']!);
      _task.value.taskDate = arguments;
      taskDate = _task.value.taskDate.obs;
      currentPageMode.value = PageMode.NEW_MODE;
      return;
    }
  }

  ////// manage PAGE MODES ///////
  Rx<PageMode> currentPageMode = PageMode.NEW_MODE.obs;
  RxBool isViewMode = false.obs;
  RxBool isNewMode = false.obs;
  RxBool isUpdateMode = false.obs;

  setPageModesHelper() {
    if (currentPageMode.value == PageMode.VIEW_MODE) {
      isViewMode.value = true;
      isUpdateMode.value = false;
      isNewMode.value = false;
    } else if (currentPageMode.value == PageMode.UPDATE_MODE) {
      isViewMode.value = false;
      isUpdateMode.value = true;
      isNewMode.value = false;
    } else if (currentPageMode.value == PageMode.NEW_MODE) {
      isViewMode.value = false;
      isUpdateMode.value = false;
      isNewMode.value = true;
    }
  }

  ////// manage UPDATE MODE //////

  void floatingActionButtonChangeMode() {
    if (currentPageMode.value == PageMode.VIEW_MODE) {
      currentPageMode.value = PageMode.UPDATE_MODE;
      saveUpdateState();
      setPageModesHelper();
      return;
    }
    if (currentPageMode.value == PageMode.UPDATE_MODE) {
      currentPageMode.value = PageMode.VIEW_MODE;
      restoreUpdateState();
      setPageModesHelper();
      return;
    }
  }

  // save old state
  Map<String, dynamic> oldState = {};
  saveUpdateState() {
    oldState = {
      'task_description': taskDescriptionCtrlr.text,
      'notifyDate': notificationText.value,
      'iconState': enableNotificationIcon.value,
    };
  }

  restoreUpdateState() {
    taskDescriptionCtrlr.text = oldState['task_description'];
    notificationText.value = oldState['notifyDate'];
    enableNotificationIcon.value = oldState['iconState'];
  }

  ////// manage TASK FORM //////
  final taskDescriptionCtrlr = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  RxBool hasUserInteraction = false.obs;

  void hasUserInteractionInit() {
    hasUserInteraction.value = taskDescriptionCtrlr.text.length >= 7 ? true : false;
  }

  ////// manage SUBTASKS //////
  final subTaskTitleCtrlr = TextEditingController();

  void reorderSubtasks({required int oldIndex, required int newIndex}) {
    final item = _task.value.subTasks.removeAt(oldIndex);
    _task.value.subTasks.insert(newIndex, item);

    if (currentPageMode.value == PageMode.VIEW_MODE || currentPageMode.value == PageMode.UPDATE_MODE) {
      _task.value.save();
    }
  }

  void createSubtask() {
    _task.update(
      (val) {
        val!.subTasks.add(
          SubTaskModel(title: subTaskTitleCtrlr.text, isDone: false),
        );
        if (currentPageMode.value == PageMode.VIEW_MODE || currentPageMode.value == PageMode.UPDATE_MODE) {
          _task.value.save();
        }
        subTaskTitleCtrlr.clear();
      },
    );
  }

  void updateTextSubtask(int index) {
    _task.update(
      (val) {
        val!.subTasks[index].title = subTaskTitleCtrlr.text;
        if (currentPageMode.value == PageMode.VIEW_MODE || currentPageMode.value == PageMode.UPDATE_MODE) {
          _task.value.save();
        }
        subTaskTitleCtrlr.clear();
      },
    );
  }

  void updateStatusSubtask(int index) {
    _task.update(
      (val) {
        val!.subTasks[index].isDone = !_task.value.subTasks[index].isDone;
        if (currentPageMode.value == PageMode.VIEW_MODE || currentPageMode.value == PageMode.UPDATE_MODE) {
          _task.value.save();
        }
      },
    );
  }

  void deleteSubtask(int index) {
    _task.update((val) {
      val!.subTasks.removeAt(index);
      if (currentPageMode.value == PageMode.VIEW_MODE || currentPageMode.value == PageMode.UPDATE_MODE) {
        _task.value.save();
      }
    });
  }

  void onCancelSubtask(BuildContext context) {
    subTaskTitleCtrlr.clear();
    Navigator.of(context).pop();
  }

  ////// manage DATE CHANGE //////
  late Rx<DateTime> taskDate;
  //RxBool hasDateChangeda = false.obs;

  void saveNewDate() {
    _task.value.taskDate = taskDate.value;
    setNotificationValues();
  }

  ////// manage ICON & TEXT NOTIFICATION //////

  TimeOfDay setNotificationTime = TimeOfDay.now();
  RxBool enableNotificationIcon = false.obs;

  Rx<Icon> notificationIcon = const Icon(Icons.notifications_off_rounded).obs;
  Rx<Color> notificationColor = bluePrimary.obs;
  Rx<Text> notificationText = const Text('').obs;

  void enableDisableNotificationStyles() {
    if (isViewMode.value && _task.value.notificationTime != null) {
      enableNotificationIcon.value = true;
      setNotificationTime = TimeOfDay(hour: _task.value.notificationTime!.hour, minute: _task.value.notificationTime!.minute);
    }

    String noDateTxt = 'schedule a notification'.tr;
    final String dateTxt = '${'notify me at:'.tr} ${setNotificationTime.to24hours()}';

    if (isViewMode.value && !enableNotificationIcon.value) {
      notificationColor.value = blackBg;
      notificationIcon.value = const Icon(Icons.notifications_off_rounded);
      notificationText.value = Text(noDateTxt, style: kBodyMedium);
    }
    if (isViewMode.value && enableNotificationIcon.value) {
      notificationColor.value = blackBg;
      notificationIcon.value = const Icon(Icons.notifications_active_rounded);
      notificationText.value = Text(dateTxt, style: kBodyMedium);
    }

    if (isNewMode.value && !enableNotificationIcon.value) {
      notificationColor.value = bluePrimary;
      notificationIcon.value = const Icon(Icons.notifications_off_rounded);
      notificationText.value = Text(noDateTxt, style: kBodyMedium);
    }
    if (isNewMode.value && enableNotificationIcon.value) {
      notificationColor.value = bluePrimary;
      notificationIcon.value = const Icon(Icons.notifications_active_rounded);
      notificationText.value = Text(dateTxt, style: kBodyMedium.copyWith(color: bluePrimary));
    }

    if (isUpdateMode.value && !enableNotificationIcon.value) {
      notificationColor.value = bluePrimary;
      notificationIcon.value = const Icon(Icons.notifications_off_rounded);
      notificationText.value = Text(noDateTxt, style: kBodyMedium.copyWith(color: disabledGrey));
    }
    if (isUpdateMode.value && enableNotificationIcon.value) {
      notificationColor.value = bluePrimary;
      notificationIcon.value = const Icon(Icons.notifications_active_rounded);
      notificationText.value = Text(dateTxt, style: kBodyMedium.copyWith(color: bluePrimary));
    }
  }

  ////// manage NOTIFICATIONS //////

  late TaskModel initialTaskValues;

  void updateNotificationStatus() async {
    // caso 1: si NO habia y ahora si hay, crear notificación nueva.
    if (initialTaskValues.notificationTime == null && enableNotificationIcon.value == true) {
      await createNotification();
      return;
    }
    // caso 2: si SÍ habia pero la desactivó, borrar notificacion.
    if (initialTaskValues.notificationTime != null && enableNotificationIcon.value == false) {
      if (initialTaskValues.notificationTime!.isAfter(DateTime.now())) {
        LocalNotificationService.deleteNotification(initialTaskValues.notificationId!);
      }
      return;
    }
    // caso 3: si habia pero cambió, borrar vieja y crear nueva
    if (initialTaskValues.notificationTime != null && enableNotificationIcon.value == true && !_task.value.notificationTime!.isAtSameMomentAs(initialTaskValues.notificationTime!)) {
      if (initialTaskValues.notificationTime!.isAfter(DateTime.now())) {
        LocalNotificationService.deleteNotification(initialTaskValues.notificationId!);
      }
      await createNotification();
      return;
    }
  }

  void setNotificationValues() {
    if (enableNotificationIcon.value) {
      _task.value.notificationTime = DateTime(
        _task.value.taskDate.year,
        _task.value.taskDate.month,
        _task.value.taskDate.day,
        setNotificationTime.hour,
        setNotificationTime.minute,
      );
      _task.value.notificationId = createNotificationId();
    } else {
      _task.value.notificationTime = null;
      _task.value.notificationId = null;
    }
  }

  Future<void> createNotification({DateTime? notifdt, int? id, String? payload, String? body}) async {
    NotificationModel notif = NotificationModel(
      id: id ?? _task.value.notificationId!,
      body: 'task reminder'.tr,
      title: body ?? _task.value.description,
      time: notifdt ?? _task.value.notificationTime!,
      payload: payload ?? _task.value.key.toString(),
    );

    await notificationsUseCases.createNotificationScheduledUseCase(notification: notif);

    // await LocalNotificationService.createNotificationScheduled(
    //   id: id ?? _task.value.notificationId!,
    //   body: body ?? _task.value.description,
    //   time: notifdt ?? _task.value.notificationTime!,
    //   payload: payload ?? _task.value.key.toString(),
    //   fln: localNotifications,
    // );
  }

  postposeNotification(Duration duration) {
    // estos argumentos vienen del servicio de notificaciones
    // var args = Get.arguments['taskId']!;
    // var task = tasksBox.get(int.parse(args))!;
    _task.value.notificationTime = DateTime.now().add(duration);
    _task.value.save();
    _createNotificationREFACTORIZED(task: _task.value);
  }

  

  Future<void> _createNotificationREFACTORIZED({required TaskModel task}) async {

    NotificationModel notif = NotificationModel(
      id: createNotificationId(),
      body: 'task reminder'.tr,
      title: task.description,
      time: task.notificationTime!,
      payload: task.key.toString(),
    );
    await notificationsUseCases.createNotificationScheduledUseCase(notification: notif);

    // await LocalNotificationService.createNotificationScheduled(
    //   id: createNotificationId(),
    //   body: task.description,
    //   time: task.notificationTime!,
    //   payload: task.key.toString(),
    //   fln: localNotifications,
    // );
  }

  ////// manage SAVE //////
  final InitialPageController _initialPageController = Get.put(InitialPageController());
  RxBool isChecked = false.obs;

  void deleteTask() {
    AppConfigModel config = userPrefs.get('appConfig')!;
    String tmp = _task.value.description;

    // si es tarea repetida //
    if (isChecked.value) {
      // buscar todas las tasks con el mismo repeatId
      List<TaskModel> tasks = [];
      for (var element in tasksBox.values) {
        if (element.repeatId == _task.value.repeatId) {
          tasks.add(element);
        }
      }
      // buscar las notif y borrarlas
      for (var element in tasks) {
        if (element.notificationTime != null && element.notificationTime!.isAfter(DateTime.now())) {
          LocalNotificationService.deleteNotification(element.notificationId!);
        }
      }
      // borrar las tasks con el mismo id
      for (var element in tasks) {
        element.delete();
      }
    }

    // si NO es tarea repetida //
    if (!isChecked.value) {
      if (_task.value.notificationTime != null && _task.value.notificationTime!.isAfter(DateTime.now())) {
        LocalNotificationService.deleteNotification(_task.value.notificationId!);
      }
      if (_task.value.key == 0) {
        config.createSampleTask = false;
        config.save();
      }
      _task.value.delete();
    }

    Get.find<InitialPageController>().buildInfo();
    Get.offAllNamed(Routes.INITIAL_PAGE);
    showSnackBar(
      titleText: 'task deleted'.tr,
      messageText: tmp,
    );
  }

  // notificaciones, casos de edicion:
  // 1- si tenia notificacion activa y la desactiva
  // 2- si modifica la fecha de la notificacion
  // 3- issue: si tenia una notificacion activa (ya creada) y actualiza algo de la tarea,
  //    se genera una notif nueva a la misma hora

  void saveOrUpdateTask(BuildContext context) {
    var isFormValid = formKey.currentState!.validate();
    if (isFormValid) {
      _task.value.notificationTime != null ? validateNotification(context) : confirmAndNavigate();
    }
  }

  void validateNotification(BuildContext context) {
    if (_task.value.notificationTime!.isBefore(DateTime.now())) {
      myCustomDialog(
        context: context,
        title: 'atention !'.tr,
        subtitle: 'You cant create a...'.tr,
        okTextButton: 'ok'.tr,
        iconPath: 'assets/info.svg',
        iconColor: bluePrimary,
        onPressOk: () => Navigator.of(context).pop(),
      );
    } else {
      confirmAndNavigate();
    }
  }

  void confirmAndNavigate() async {
    _task.value.description = taskDescriptionCtrlr.text;

    if (isUpdateMode.value) {
      updateNotificationStatus();
      _task.value.save();
      currentPageMode.value = PageMode.VIEW_MODE;
      setPageModesHelper();
      enableDisableNotificationStyles();
      showSnackBar(
        titleText: 'task updated'.tr,
        messageText: _task.value.description,
        marginFromBottom: 80,
      );
    }

    if (isNewMode.value) {
      tasksBox.add(_task.value);

      if (enableNotificationIcon.value) {
        await createNotification();
      }

      if (isTaskRepeat.value) {
        generateRepeatedTasks();
      }

      _initialPageController.buildInfo();
      Get.offAllNamed(Routes.INITIAL_PAGE);
      showSnackBar(
        titleText: 'new task created'.tr,
        messageText: _task.value.description,
      );
    }
  }

  ////// manage REPEAT TASK //////
  final RxBool isTaskRepeat = false.obs;

  void generateRepeatedTasks() async {
    // list
    List<TaskModel> taskList = [];
    final String repeatId = UniqueKey().toString();

    // agregar el repeatId a la tarea actual
    _task.value.repeatId = repeatId;

    // iterar
    for (var i = 1; i < 365; i++) {
      var date = _task.value.taskDate.add(Duration(days: i));
      int notificationId = createNotificationId();
      //
      if (date.weekday == _task.value.taskDate.weekday) {
        // agregar a la lista
        taskList.add(_task.value.copyWith(
          description: _task.value.description,
          taskDate: date,
          notificationTime: _task.value.notificationTime,
          status: _task.value.status,
          notificationId: notificationId,
          repeatId: repeatId,
          subTasks: _task.value.subTasks.map((e) => e.copyWith(value: e.title, isDone: e.isDone)).toList(),
        ));
        // crear notif
        if (enableNotificationIcon.value) {
          await createNotification(
            notifdt: _task.value.notificationTime!.add(Duration(days: i)),
            id: notificationId,
            payload: _task.value.notificationTime!.add(Duration(days: i)).toString(),
          );
        }
      }
    }
    // add all to box
    tasksBox.addAll(taskList);
  }

  ////// manage NAVIGATION //////
  Future<bool> onWillPop(BuildContext context) async {
    if (isNewMode.value) {
      cancelAndNavigate(context);
      return true;
    } else if (isViewMode.value) {
      cancelAndNavigate(context);
      return true;
    } else {
      return false;
    }
  }

  void cancelAndNavigate(BuildContext context) {
    _initialPageController.buildInfo();
    Get.offAllNamed(Routes.INITIAL_PAGE);
  }

  ////// manage GOOGLE ADS //////
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
  */
}
