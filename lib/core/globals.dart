import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Globals {
  static final GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> myScaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<AnimatedListState> animatedListStateKey = GlobalKey();
  static final GlobalKey<IntroductionScreenState> introKey = GlobalKey<IntroductionScreenState>();

  // si llega una notificacion con la app cerrada, el payload se guarda acá
  // para poder recuperalo en el BuildPage y abrir esta tarea al inicio
  static String? closedAppPayload;
}
