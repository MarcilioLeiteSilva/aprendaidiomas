import 'package:flutter/material.dart';

enum LanguageTarget { english, french, spanish, german, italian }

class AppConfig {
  // ==========================================
  // CONFIGURAÇÃO MESTRE - O BOTÃO DO PÂNICO
  // ==========================================
  // Altere apenas esta variável para mudar todo o app para outro idioma!
  static const LanguageTarget activeLanguage = LanguageTarget.english;

  // URL do backend FastAPI (use 10.0.2.2 para emulador Android, IP real para dispositivo)
  static const String backendUrl = 'https://appidiomas-backend-idiomas.gtalg3.easypanel.host';

  // 1. CONFIGURAÇÕES VISUAIS (TEMA)
  static Color get primaryColor {
    switch (activeLanguage) {
      case LanguageTarget.french:
        return const Color(0xFFE11D48); // Vermelho Sofisticado (Francês)
      case LanguageTarget.spanish:
        return const Color(0xFFF59E0B); // Amarelo/Laranja (Espanhol)
      case LanguageTarget.german:
        return const Color(0xFF111827); // Charcoal (Alemão)
      case LanguageTarget.english:
        return const Color(0xFF6366F1); // Indigo (Inglês)
      case LanguageTarget.italian:
        return const Color(0xFF009246); // Verde Vibrante (Itália)
    }
  }

  // 2. TEXTOS E NOMES
  static String get appName {
    switch (activeLanguage) {
      case LanguageTarget.french:
        return "Aprenda Francês Premium";
      case LanguageTarget.spanish:
        return "Aprenda Espanhol Premium";
      case LanguageTarget.german:
        return "Aprenda Alemão Premium";
      case LanguageTarget.english:
        return "Aprenda Inglês Premium";
      case LanguageTarget.italian:
        return "Aprenda Italiano Premium";
    }
  }

  // 3. BANCO DE DADOS (Coluna no SQlite)
  static String get databaseColumn {
    switch (activeLanguage) {
      case LanguageTarget.french:
        return "French";
      case LanguageTarget.spanish:
        return "Spanish";
      case LanguageTarget.german:
        return "German";
      case LanguageTarget.english:
        return "English";
      case LanguageTarget.italian:
        return "Italian";
    }
  }

  // 4. VOZ (Text-To-Speech Locale)
  static String get ttsLocale {
    switch (activeLanguage) {
      case LanguageTarget.french:
        return "fr-FR";
      case LanguageTarget.spanish:
        return "es-ES";
      case LanguageTarget.german:
        return "de-DE";
      case LanguageTarget.english:
        return "en-US";
      case LanguageTarget.italian:
        return "it-IT";
    }
  }

  // 5. IDs DE ANÚNCIOS (Um conjunto por idioma)
  // Nota: Você deve preencher os IDs reais do AdMob da França/outros aqui quando os tiver.
  static String get bannerAdUnitId {
    switch (activeLanguage) {
      case LanguageTarget.french:
        return "ca-app-pub-6887857057070736/COLOQUE_AQUI_O_ID_FRANCA_BANNER";
      case LanguageTarget.english:
        return "ca-app-pub-6887857057070736/1909879083";
      case LanguageTarget.spanish:
      case LanguageTarget.german:
      case LanguageTarget.italian:
        return "ca-app-pub-6887857057070736/1909879083";
    }
  }

  static String get interstitialAdUnitId {
    switch (activeLanguage) {
      case LanguageTarget.french:
        return "ca-app-pub-6887857057070736/COLOQUE_AQUI_O_ID_FRANCA_INTERSTICIAL";
      case LanguageTarget.english:
        return "ca-app-pub-6887857057070736/9757280210";
      case LanguageTarget.spanish:
      case LanguageTarget.german:
      case LanguageTarget.italian:
        return "ca-app-pub-6887857057070736/9757280210";
    }
  }

  static String get rewardedAdUnitId {
    switch (activeLanguage) {
      case LanguageTarget.french:
        return "ca-app-pub-6887857057070736/COLOQUE_AQUI_O_ID_FRANCA_PREMIADO";
      case LanguageTarget.english:
        return "ca-app-pub-6887857057070736/3032089761";
      case LanguageTarget.spanish:
      case LanguageTarget.german:
      case LanguageTarget.italian:
        return "ca-app-pub-6887857057070736/3032089761";
    }
  }
}
