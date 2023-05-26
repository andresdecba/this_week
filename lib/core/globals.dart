import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Globals {
  static final GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<AnimatedListState> animatedListStateKey = GlobalKey();
  static final GlobalKey<IntroductionScreenState> introKey = GlobalKey<IntroductionScreenState>();
}
