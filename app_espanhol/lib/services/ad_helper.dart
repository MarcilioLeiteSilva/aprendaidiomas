import 'dart:io';
// import '../config/app_config.dart'; // Descomentado quando voltar para produção

class AdHelper {
  // ==========================================
  // MODO TESTE - IDs oficiais do Google AdMob
  // ==========================================
  // Para voltar à produção, descomente o import acima e troque
  // os returns abaixo pelos métodos do AppConfig.
  
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // TEST Banner
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // TEST Banner iOS
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // TEST Interstitial
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // TEST Interstitial iOS
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // TEST Rewarded
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // TEST Rewarded iOS
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
