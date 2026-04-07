import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/kundli/presentation/providers/kundli_provider.dart';
import 'features/horoscope/presentation/providers/horoscope_provider.dart';
import 'features/compatibility/presentation/providers/compatibility_provider.dart';
import 'features/remedies/presentation/providers/remedies_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed (demo mode): $e');
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const KundliApp());
}

class KundliApp extends StatelessWidget {
  const KundliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KundliProvider()),
        ChangeNotifierProvider(create: (_) => HoroscopeProvider()),
        ChangeNotifierProvider(create: (_) => CompatibilityProvider()),
        ChangeNotifierProvider(create: (_) => RemediesProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp.router(
            title: 'Kundli App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            routerConfig: AppRouter.router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('hi', 'IN'),
            ],
            locale: settings.locale,
          );
        },
      ),
    );
  }
}
