import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/my_app_config.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/services/ad_mob_service.dart';
import 'package:todoapp/services/local_notifications_service.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';
import 'package:todoapp/ui/shared_components/snackbar.dart';
import 'package:todoapp/utils/helpers.dart';

enum PageMode { VIEW_MODE, UPDATE_MODE, NEW_MODE }

class FormsPageController extends GetxController {
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
  void onClose() {
    taskDescriptionCtrlr.dispose();
    subTaskTitleCtrlr.dispose();
    super.onClose();
  }

  ////// manage HIVE //////
  final tasksBox = Boxes.getTasksBox();

  ////// manage APP CONFIG //////
  final userPrefs = Boxes.getMyAppConfigBox();

  ////// manage INITIAL PAGE ACTIVITY //////
  Task get getTask => _task.value;
  final Rx<Task> _task = Task(
    description: '',
    taskDate: DateTime.now(),
    notificationTime: null,
    status: TaskStatus.PENDING.toValue,
    subTasks: [],
    notificationId: null,
  ).obs;

  void setInitialConfig() {
    // view mode
    if (Get.arguments['taskId'] != null) {
      _task.value = tasksBox.get(int.parse(Get.arguments['taskId']!))!;
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
      );
      return;
    }
    // new mode on a specific date
    if (Get.arguments['date'] != null) {
      var arguments = DateTime.parse(Get.arguments['date']!);
      _task.value.taskDate = arguments;
      taskDate = _task.value.taskDate.obs;
      currentPageMode.value = PageMode.NEW_MODE;
      return;
    }
  }

  ///////////

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
          SubTask(title: subTaskTitleCtrlr.text, isDone: false),
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
  Rx<Color> notificationColor = blue_primary.obs;
  Rx<Text> notificationText = const Text('').obs;

  void enableDisableNotificationStyles() {
    if (isViewMode.value && _task.value.notificationTime != null) {
      enableNotificationIcon.value = true;
      setNotificationTime = TimeOfDay(hour: _task.value.notificationTime!.hour, minute: _task.value.notificationTime!.minute);
    }

    String noDateTxt = 'schedule a notification'.tr;
    final String dateTxt = '${'notify me at:'.tr} ${setNotificationTime.to24hours()}';

    if (isViewMode.value && !enableNotificationIcon.value) {
      notificationColor.value = black_bg;
      notificationIcon.value = const Icon(Icons.notifications_off_rounded);
      notificationText.value = Text(noDateTxt, style: kBodyMedium);
    }
    if (isViewMode.value && enableNotificationIcon.value) {
      notificationColor.value = black_bg;
      notificationIcon.value = const Icon(Icons.notifications_active_rounded);
      notificationText.value = Text(dateTxt, style: kBodyMedium);
    }

    if (isNewMode.value && !enableNotificationIcon.value) {
      notificationColor.value = blue_primary;
      notificationIcon.value = const Icon(Icons.notifications_off_rounded);
      notificationText.value = Text(noDateTxt, style: kBodyMedium);
    }
    if (isNewMode.value && enableNotificationIcon.value) {
      notificationColor.value = blue_primary;
      notificationIcon.value = const Icon(Icons.notifications_active_rounded);
      notificationText.value = Text(dateTxt, style: kBodyMedium.copyWith(color: blue_primary));
    }

    if (isUpdateMode.value && !enableNotificationIcon.value) {
      notificationColor.value = blue_primary;
      notificationIcon.value = const Icon(Icons.notifications_off_rounded);
      notificationText.value = Text(noDateTxt, style: kBodyMedium.copyWith(color: disabled_grey));
    }
    if (isUpdateMode.value && enableNotificationIcon.value) {
      notificationColor.value = blue_primary;
      notificationIcon.value = const Icon(Icons.notifications_active_rounded);
      notificationText.value = Text(dateTxt, style: kBodyMedium.copyWith(color: blue_primary));
    }
  }

  ////// manage NOTIFICATIONS //////

  late Task initialTaskValues;

  void updateNotificationStatus() {
    // caso 1: si NO habia y ahora si hay, crear notificación nueva.
    if (initialTaskValues.notificationTime == null && enableNotificationIcon.value == true) {
      createNotification();
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
      createNotification();
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

  void createNotification() {
    LocalNotificationService.showtNotificationScheduled(
      time: _task.value.notificationTime!,
      id: _task.value.notificationId!, //createNotificationId(),
      body: _task.value.description,
      payload: _task.value.key.toString(),
      fln: localNotifications,
    );
  }

  ////// manage SAVE //////
  final InitialPageController _initialPageController = Get.put(InitialPageController());

  void deleteTask(BuildContext context) {
    MyAppConfig config = userPrefs.get('appConfig')!;
    String tmp = _task.value.description;

    myCustomDialog(
      context: context,
      title: 'delete task ?'.tr,
      subtitle: 'this action will delete...'.tr,
      cancelTextButton: 'cancel'.tr,
      okTextButton: 'delete'.tr,
      iconPath: 'assets/warning.svg',
      iconColor: warning,
      onPressOk: () {
        if (_task.value.notificationTime != null && _task.value.notificationTime!.isAfter(DateTime.now())) {
          LocalNotificationService.deleteNotification(_task.value.notificationId!);
        }
        if (_task.value.key == 0) {
          config.createSampleTask = false;
          config.save();
        }
        _task.value.delete();
        Get.find<InitialPageController>().buildInfo();
        Get.offAllNamed(Routes.INITIAL_PAGE);
        showSnackBar(
          titleText: 'task deleted'.tr,
          messageText: tmp,
        );
      },
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
        iconColor: blue_primary,
        onPressOk: () => Navigator.of(context).pop(),
      );
    } else {
      confirmAndNavigate();
    }
  }

  void confirmAndNavigate() async {
    if (isUpdateMode.value) {
      _task.value.description = taskDescriptionCtrlr.text;
      //createNotification();
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
      _task.value.description = taskDescriptionCtrlr.text;
      tasksBox.add(_task.value);
      enableNotificationIcon.value ? createNotification() : null;
      _initialPageController.buildInfo();
      Get.offAllNamed(Routes.INITIAL_PAGE);
      showSnackBar(
        titleText: 'new task created'.tr,
        messageText: _task.value.description,
      );
    }
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
      //adUnitId: AdMobService.bannerTwoAdUnit!,
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
