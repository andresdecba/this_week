import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/hive_data_sorce/hive_data_source.dart';
import 'package:todoapp/models/app_config_model.dart';
import 'package:todoapp/models/task_model.dart';

class Globals {
  static final GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> myScaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<AnimatedListState> animatedListStateKey = GlobalKey();
  static final GlobalKey<IntroductionScreenState> introKey = GlobalKey<IntroductionScreenState>();

  // si llega una notificacion con la app cerrada, el payload se guarda acá
  // para poder recuperalo en el BuildPage y abrir esta tarea al inicio
  static String? closedAppPayload;
  static RxList<Rx<TaskModel>> tasksGlobal = RxList<Rx<TaskModel>>([]); // TODO hacer un singleton con esto

  static String initialRoute = Routes.INITIAL_PAGE;
  static Box<AppConfigModel> userPrefs = Boxes.getMyAppConfigBox();
  static AppConfigModel config = userPrefs.get('appConfig')!;

  static bool isKeepAlive = true;
}
