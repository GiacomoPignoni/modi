import 'dart:io' show Platform;

import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modi/models/config.dart';
import 'package:modi/services/analytics_service.dart';
import 'package:modi/services/config_service.dart';

class AdService {
  final ConfigService _configSvc = GetIt.I.get<ConfigService>();
  final AnalyticsService _analyticsSvc = GetIt.I.get<AnalyticsService>();

  InterstitialAd? _fullPageAd;

  Future<void> init() async {
    await MobileAds.instance.initialize();

    // Register debug device for dev env
    if(_configSvc.env == Env.dev) {
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: ["kGADSimulatorID"])
      );
    }

    await _loadFullPageAd();
  }

  Future<void> showFullPage() async {
    if(_fullPageAd != null) {
      _fullPageAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          _fullPageAd!.dispose();
          _loadFullPageAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          _fullPageAd!.dispose();
          _loadFullPageAd();
        },
        onAdImpression: (InterstitialAd ad) => _analyticsSvc.I.logEvent(name: AnalyticsEvent.adImpression),
      );

      await _fullPageAd!.show();
    }
  }

  Future<void> _loadFullPageAd() async {
    await InterstitialAd.load(
      adUnitId: Platform.isIOS ? _configSvc.fullPageAdIdiOS : _configSvc.fullPageAdIdAndroid,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) => _fullPageAd = ad,
        onAdFailedToLoad: (LoadAdError error) => _analyticsSvc.I.logEvent(name: AnalyticsEvent.failedToLoadAd), 
      )
    );
  }

  Future<BannerAd> getBannerAd() async {
    final bannerAd = BannerAd(
      adUnitId: Platform.isIOS ? _configSvc.bannerAdIdiOS : _configSvc.bannerAdIdAndroid,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener()
    );

    await bannerAd.load();
    return bannerAd;
  }
}
