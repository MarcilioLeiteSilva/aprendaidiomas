import 'dart:io';
import '../config/app_config.dart';

class AdHelper {
  // Configured with Production Ads IDs. 
  // Ensure the App is verified in AdMob console.
  
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.bannerAdUnitId;
    } else if (Platform.isIOS) {
      // Por enquanto iOS mantém teste ou você pode adicionar no AppConfig também
      return 'ca-app-pub-6887857057070736/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.interstitialAdUnitId;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6887857057070736/4411468910';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.rewardedAdUnitId;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6887857057070736/1712485313';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
