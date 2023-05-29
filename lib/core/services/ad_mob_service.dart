import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

mixin AdMobService {
  // TEST BANNER
  static String? get testBanner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  // Initial page Banner
  static String? get initialPageBanner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9058342620461440/8299319891';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9058342620461440/8686316796';
    }
    return null;
  }

  // Forms page Banner
  static String? get formPageBanner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9058342620461440/3050624967';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9058342620461440/8753806961';
    }
    return null;
  }

  // Postpose page Banner
  static String? get postposePageBanner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9058342620461440/1390532667';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9058342620461440/8753806961';
    }
    return null;
  }

  void loadBannerAd({required BannerAdListener bannerListener, String? adUnitId}) async {
    // initialPageBannerAdtomar la medida de la pantalla
    AnchoredAdaptiveBannerAdSize? size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(Get.context!).size.width.truncate(),
    );
    // cargar ad
    BannerAd(
      adUnitId: adUnitId ?? AdMobService.testBanner!,
      size: size ?? AdSize.banner,
      request: const AdRequest(),
      listener: bannerListener,
    ).load();
  }
}


/*
//// DOCUMENTATION ////
https://developers.google.com/admob/flutter/quick-start?hl=es
https://www.youtube.com/watch?v=m0d_pbgeeG8&t=325s


//// IDS de prueba ////
banner para android e ios: ca-app-pub-3940256099942544/630097811
mas ids de prueba: https://developers.google.com/admob/android/test-ads?hl=es

//// IDS reales para producción: ////
android:
banner_1: ca-app-pub-9058342620461440/8299319891
banner_2:
ios:
banner_1: ca-app-pub-9058342620461440/8686316796
banner_2:
*/
