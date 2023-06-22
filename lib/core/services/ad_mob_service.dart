import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/*
TUTORIAL: https://developers.google.com/admob/flutter/banner/inline-adaptive?hl=es
importante: hay ejemplos de otros tipos de banner, ver !
*/

// KEYS FOR TEST
const _androidAdUnitKeyTest = 'ca-app-pub-3940256099942544/6300978111';
const _iOsAdUnitKeyTest = 'ca-app-pub-3940256099942544/6300978111';

// KEYS FOR PRODUCTION
const _androidAdUnitKeyProd = 'ca-app-pub-9058342620461440/8299319891';
const _iOsAdUnitKeyProd = 'ca-app-pub-9058342620461440/8686316796';

// OTHERS
const _padding = 5.0;
const _radius = 5.0;

class AdMobService extends StatefulWidget {
  const AdMobService({
    required this.isProductionVersion,
    super.key,
  });

  final bool isProductionVersion;

  @override
  State<AdMobService> createState() => _AdMobServiceState();
}

class _AdMobServiceState extends State<AdMobService> {
  BannerAd? _anchoredAdaptiveAd;
  LoadAdError? _loadError;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.of(context).size.width.truncate() - (_padding.toInt() * 2));

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      //  adUnitId: Platform.isAndroid
      //     ? widget.androidAdUnitKey != null
      //         ? widget.androidAdUnitKey!
      //         : _androidAdUnitKeyTest
      //     : widget.iOsAdUnitKey != null
      //         ? widget.iOsAdUnitKey!
      //         : _iOsAdUnitKeyTest,

      adUnitId: Platform.isAndroid
          ? widget.isProductionVersion
              ? _androidAdUnitKeyProd
              : _androidAdUnitKeyTest
          : widget.isProductionVersion
              ? _iOsAdUnitKeyProd
              : _iOsAdUnitKeyTest,

      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          setState(() {
            _loadError = error;
            _isLoaded = true;
            ad.dispose();
          });
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    /// LOADING ///
    if (!_isLoaded) {
      return const _BuildAd(
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      );
    }

    /// ERROR ///
    if (_loadError != null && _isLoaded) {
      return const _BuildAd(
        child: Text(
          "Error while connecting to ad server.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    /// AD LOADED ///
    if (_anchoredAdaptiveAd != null && _isLoaded) {
      return _BuildAd(
        height: _anchoredAdaptiveAd!.size.height.toDouble(),
        width: _anchoredAdaptiveAd!.size.width.toDouble(),
        child: AdWidget(ad: _anchoredAdaptiveAd!),
      );
    }
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }
}

class _BuildAd extends StatelessWidget {
  const _BuildAd({
    required this.child,
    this.height,
    this.width,
  });

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _padding),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: const BorderRadius.all(Radius.circular(_radius)),
          border: Border.all(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: _padding),
        width: width ?? double.infinity,
        height: height ?? 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: child,
        ),
      ),
    );
  }
}
