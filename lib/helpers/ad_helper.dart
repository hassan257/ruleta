import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6473425324446369/8777298860";
    } else if (Platform.isIOS) {
      // return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
      throw UnsupportedError("Unsupported platform");
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  // static String get nativeAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-6473425324446369/2277671488";
  //   } else if (Platform.isIOS) {
  //     // return "<YOUR_IOS_NATIVE_AD_UNIT_ID>";
  //     throw UnsupportedError("Unsupported platform");
  //   } else {
  //     throw UnsupportedError("Unsupported platform");
  //   }
  // }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6473425324446369/6003757875';
    } else if (Platform.isIOS) {
      // return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
      throw UnsupportedError('Unsupported platform');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}