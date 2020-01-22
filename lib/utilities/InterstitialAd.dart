import 'package:firebase_admob/firebase_admob.dart';
import 'package:quiz/Constants/ApiKey.dart';

InterstitialAd createInterstitialAd(int id) {
  return InterstitialAd(
    adUnitId: id == 1 ? interstitialAdUnit1 : interstitialAdUnit2,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event $event in $id");
    },
  );
}
