import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/hive_data_sorce/hive_data_source.dart';
import 'package:todoapp/ui/commons/styles.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);
  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  // onboarding done
  var appConfig = Boxes.getMyAppConfigBox().get('appConfig')!;
  void _onDone() {
    appConfig.isOnboardingDone = true;
    appConfig.save();
    Get.toNamed(Routes.INITIAL_PAGE);
    //Get.offAllNamed(Routes.INITIAL_PAGE); //no usar 'Get.off' x que se clava si la saltas rapido
  }

  void _onSkip() {
    Get.toNamed(Routes.INITIAL_PAGE);
    //Get.offAllNamed(Routes.INITIAL_PAGE); //no usar 'Get.off' x que se clava si la saltas rapido
  }

  // call image
  Widget _buildImage(String assetName, [double width = 600]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
      imagePadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      titlePadding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      titleTextStyle: kHeadlineLarge.copyWith(color: yellowPrimary),
      contentMargin: EdgeInsets.zero,
      bodyTextStyle: kTitleMedium,
      pageColor: Colors.white,
      imageFlex: 5,
      bodyFlex: 2,
      imageAlignment: Alignment.bottomCenter,
      bodyAlignment: Alignment.topCenter,
    );

    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          key: Globals.introKey,
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: true,
          autoScrollDuration: 5000,
          onDone: () => _onDone(),
          onSkip: () => _onSkip(),
          showSkipButton: true,
          back: const Icon(Icons.arrow_back),
          skip: Text('skip_onboarding'.tr, style: kTitleLarge.copyWith(color: bluePrimary)),
          next: const Icon(Icons.arrow_forward, size: 30, color: bluePrimary),
          done: Text('done_onboarding'.tr, style: kTitleLarge.copyWith(color: bluePrimary)),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsPadding: const EdgeInsets.all(20),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: bluePrimary,
            activeSize: Size(22.0, 10.0),
            activeColor: bluePrimary,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          dotsContainerDecorator: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          //globalHeader: ,

          ////// pages /////
          pages: [
            PageViewModel(
              title: 'welcome'.tr,
              body: 'welcome_desc'.tr,
              image: _buildImage('onboarding_0.jpg'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: 'step one'.tr,
              body: 'step one_desc'.tr,
              image: _buildImage('onboarding_1.jpg'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "step two".tr,
              body: "step two_desc".tr,
              image: _buildImage('onboarding_2.jpg'),
              decoration: pageDecoration,
            ),
          ],
        ),
      ),
    );
  }
}
