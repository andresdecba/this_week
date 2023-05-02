import 'dart:io';
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
  

  final BannerAdListener listenerAaa = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
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
