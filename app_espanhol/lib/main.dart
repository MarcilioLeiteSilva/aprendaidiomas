import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/splash_screen.dart';
import 'services/database_helper.dart';
import 'services/user_service.dart';
import 'services/notification_service.dart';
import 'services/billing_service.dart';

import 'theme/app_theme.dart';

import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("🚀 [DEBUG main] WidgetsFlutterBinding inicializado");

  MobileAds.instance.initialize();
  debugPrint("🚀 [DEBUG main] MobileAds.initialize() acionado");

  // Pre-initialize safe reference to SQLite static loads
  await DatabaseHelper().database;
  debugPrint("🚀 [DEBUG main] DatabaseHelper inicializado");

  // Initialize local user service
  await UserService.initialize();
  debugPrint("🚀 [DEBUG main] UserService inicializado — hasCustomProfile: ${UserService.hasCustomProfile}");

  // Inicializa o serviço de pagamentos da Google Play e sincronização com o backend
  await BillingService.initialize();
  debugPrint("🚀 [DEBUG main] BillingService inicializado");


  // Initialize local notifications in background (non-blocking)
  NotificationService.initialize().then((_) {
    debugPrint("🚀 [DEBUG main] NotificationService inicializado com sucesso");
  }).catchError((e) {
    debugPrint("🚀 [DEBUG main] Erro ao inicializar NotificationService: $e");
  });

  debugPrint("🚀 [DEBUG main] Chamando runApp()...");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
