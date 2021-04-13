import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/Constants/ApiKey.dart';

InterstitialAd createInterstitialAd({@required Function() onLoad}) {
  return InterstitialAd(
    adUnitId: interstitialAdUnit,
    request: AdRequest(),
    listener: AdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('mAd loaded.');
        onLoad();
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('mAd failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('mAd opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) {
        ad.dispose();
        print('mAd closed.');
      },
      // Called when an ad is in the process of leaving the application.
      onApplicationExit: (Ad ad) => print('Left application.'),
    ),
  );
}

BannerAd createBannerAd({@required Function(BannerAd) onLoad}) {
  return BannerAd(
    adUnitId: bannerAdUnit,
    size: AdSize.banner,
    request: AdRequest(),
    listener: AdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('mAd loaded.');
        onLoad(ad);
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('mAd failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('mAd opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('mAd closed.'),
      // Called when an ad is in the process of leaving the application.
      onApplicationExit: (Ad ad) => print('Left application.'),
    ),
  );
}
