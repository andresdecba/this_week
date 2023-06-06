import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/hive_data_sorce/hive_data_source.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/notification_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/core/services/ad_mob_service.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';
import 'package:todoapp/ui/shared_components/snackbar.dart';
import 'package:todoapp/use_cases/local_notifications_use_cases.dart';
import 'package:todoapp/utils/helpers.dart';
import 'dart:async';

enum PostposeEnum { fifteenMinutes, oneHour, threeHours, oneDay, personalized }

class PostPosePageController extends GetxController with AdMobService, StateMixin<dynamic> {


  // TODO: LEER ->
  /*
  ////////////////////////////////////////////////////////////////////
  /// ¡ ATENCION ! HAY QUE RAFACTORIZAR ESTE CONTROLLER
  /// YA QUE SE CAMBIO EL [localNotificationsUseCases]
  /// PERO NO SE ADAPTÓ ESTE ARCHIVO POR PAJA BASICAMENTE xD...
  /// SÓLO LA FORMA COMO SE PASAN LOS PARAMETROS A [localNotificationsUseCases]
  ////////////////////////////////////////////////////////////////////
  */

  PostPosePageController({
    required this.localNotificationsUseCases,
  });

  @override
  void onInit() {
    getCurrentTask();
    fillNotificationValues();
    setTimer();
    super.onInit();
  }

  @override
  void onReady() {
    loadBannerAd(bannerListener: initialPageBannerListener());
    //loadBannerAd(bannerListener: initialPageBannerListener(), adUnitId: AdMobService.postposePageBanner!);
    super.onReady();
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  ///// NOTIFICATIONS /////
  final LocalNotificationsUseCases localNotificationsUseCases;

  //// manage HIVE //////
  final tasksBox = Boxes.getTasksBox();
  late TaskModel task;
  late NotificationModel _newNotification;

  void getCurrentTask() {
    // argumentos desde la notificacion cuando la app esta cerrada
    if (notificationPayload != null) {
      task = tasksBox.get(int.parse(notificationPayload!))!;
      return;
    }
    // argumentos desde notificacion cuando la app esta abierta o en segundo plano
    if (Get.arguments['notificationPAYLOAD'] != null) {
      task = tasksBox.get(int.parse(Get.arguments['notificationPAYLOAD']!))!;
      return;
    }
  }

  void fillNotificationValues() {
    _newNotification = NotificationModel(
      id: createNotificationId(),
      body: 'task reminder'.tr,
      title: task.description,
      time: task.notificationData!.time,
      payload: task.key.toString(),
    );
  }

  //// manage SELECT ITEM /////
  Rx<PostposeEnum> selectedItem = PostposeEnum.fifteenMinutes.obs;

  String setTitle(PostposeEnum data) {
    switch (data) {
      case PostposeEnum.fifteenMinutes:
        return '15 minutes'.tr;
      case PostposeEnum.oneHour:
        return '1 hour'.tr;
      case PostposeEnum.threeHours:
        return '3 hours'.tr;
      case PostposeEnum.oneDay:
        return '1 day'.tr;
      case PostposeEnum.personalized:
        return 'personalized'.tr;
      default:
        return '15 minutes'.tr;
    }
  }

  RxString subtitle = ''.obs;
  String setSubTitle(PostposeEnum data) {
    final DateTime tmp1 = DateTime.now().add(const Duration(minutes: 15));
    final DateTime tmp2 = DateTime.now().add(const Duration(hours: 1));
    final DateTime tmp3 = DateTime.now().add(const Duration(hours: 3));
    final DateTime tmp4 = _newNotification.time.add(const Duration(days: 1));
    switch (data) {
      case PostposeEnum.fifteenMinutes:
        return '${'today'.tr}, ${'at'.tr} ${timeFormater(tmp1)}';
      case PostposeEnum.oneHour:
        return '${'today'.tr}, ${'at'.tr} ${timeFormater(tmp2)}';
      case PostposeEnum.threeHours:
        return '${'today'.tr}, ${'at'.tr} ${timeFormater(tmp3)}';
      case PostposeEnum.oneDay:
        return '${'tomorrow'.tr}, ${'at'.tr} ${timeFormater(tmp4)}';
      case PostposeEnum.personalized:
        if (personalizedNotificationDateTime.value != null && personalizedTaskDate != null) {
          return '${longDateFormaterWithoutYear(personalizedNotificationDateTime.value!)}, ${'at'.tr} ${timeFormater(personalizedNotificationDateTime.value!)}';
        } else {
          return 'select...'.tr;
        }
      default:
        return '...';
    }
  }

  // refrescar el subtitulo cada un minuto si el usuario se demora
  // mucho tiempo en seleccionar una opción.
  late Timer timer;
  void setTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      subtitle.refresh();
      if (timer.tick == 10) {
        cancelPostpose();
      }
    });
  }

  bool isSelected(PostposeEnum data) {
    return data == selectedItem.value;
  }

  void onChanged(PostposeEnum value, BuildContext context) async {
    selectedItem.value = value;
    if (value == PostposeEnum.personalized) {
      await datePicker();
    }
  }

  ///// manage SAVE /////
  /// TODO final InitialPageController _initialPageController = Get.put(InitialPageController());

  void savePostpose(PostposeEnum data, BuildContext context) {
    switch (data) {
      // si pospone para HOY: DateTime.now() + el tiempo a posponer.
      case PostposeEnum.fifteenMinutes:
        _newNotification.time = DateTime.now().add(const Duration(minutes: 15));
        break;
      case PostposeEnum.oneHour:
        _newNotification.time = DateTime.now().add(const Duration(hours: 1));
        break;
      case PostposeEnum.threeHours:
        _newNotification.time = DateTime.now().add(const Duration(hours: 3));
        break;
      // si pospone para MAÑANA:, conservar la hora original de la notificación.
      case PostposeEnum.oneDay:
        task.taskDate = task.taskDate.add(const Duration(days: 1));
        _newNotification.time = _newNotification.time.add(const Duration(days: 1));
        break;
      case PostposeEnum.personalized:
        if (personalizedNotificationDateTime.value != null && personalizedTaskDate != null) {
          task.taskDate = personalizedTaskDate!;
          _newNotification.time = personalizedNotificationDateTime.value!;
          break;
        } else {
          myCustomDialog(
            context: Get.context!,
            title: 'select date and time'.tr,
            onPressOk: () => Get.back(),
          );
          return;
        }
    }
    saveAndNavigate(context);
  }

  void saveAndNavigate(BuildContext context) async {

    Rx<TaskModel> taskObs = task.obs;
    TimeOfDay newTime = TimeOfDay(
      hour: _newNotification.time.hour,
      minute: _newNotification.time.minute,
    );

    localNotificationsUseCases.createNotification(
      task: taskObs,
      newTime: newTime,
    );

    Get.offAllNamed(Routes.INITIAL_PAGE);
    showSnackBar(
      titleText: 'postponed task title'.tr,
      messageText: '${'postponed task description'.tr} ${longDateFormaterWithoutYear(task.taskDate)}, ${'at'.tr} ${timeFormater(_newNotification.time)}',
    );
  }

  ///// manage CANCEL AND NAVIGATE /////
  void cancelPostpose() {
    Get.offAllNamed(Routes.INITIAL_PAGE);
  }

  ///// manage PERSONALIZED DATE AND TIME /////
  DateTime? personalizedTaskDate;
  Rxn<DateTime> personalizedNotificationDateTime = Rxn<DateTime>();

  Future<void> datePicker() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: task.taskDate,
      firstDate: task.taskDate,
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      personalizedTaskDate = picked;
      await timePicker();
    } else {
      // ignore: avoid_print
      print('picking cancelled');
    }
  }

  Future<void> timePicker() async {
    //FocusScope.of(context).unfocus(); // hide keyboard if open
    TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().add(const Duration(minutes: 10)).minute),
    );
    if (picked != null) {
      personalizedNotificationDateTime.value = DateTime(
        personalizedTaskDate!.year, // año
        personalizedTaskDate!.month, // mes
        personalizedTaskDate!.day, // dia
        picked.hour, // hora
        picked.minute, // minuto
      );
    } else {
      // ignore: avoid_print
      print('picking cancelled');
    }
  }

  ///// manage LOAD GOOGLE AD /////
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
