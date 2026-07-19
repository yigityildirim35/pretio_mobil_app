import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pretio/l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'providers/transaction_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/currency_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/goals_provider.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';

import 'dart:async';
import 'screens/boot_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
/*
 
 Pretio (Pret-yo) Formül: Pretium (Değer/Zamanın Bedeli) + Ratio (Akıl/Hesap)
 Anlamı: "Değerin Mantığı". Neden Kusursuz? Uygulamanın o efsanevi "Zaman Maliyeti" özelliğini vurgular. 
 Bir şeyin sadece fiyatını değil, gerçek bedelini (hayatından giden saati) hesaplamayı simgeler. 
 Kulağa Premium bir kredi kartı veya üst düzey bir finans asistanı gibi gelir. 
 Sloganı: "Zamanının gerçek değerini hesapla." bu isim nasıl uygulama için
 
*/

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      // Kırmızı ekran (Red Screen) veya yayınlandığında çıkacak gri ekran yerine
      // gösterilecek zarif ve uygulamayı çökertmeyen hata arayüzü.
      ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
        return const Material(
          color: Colors.transparent,
          child: Center(
            child: Icon(Icons.error_outline, color: Colors.grey, size: 24),
          ),
        );
      };

      // Ensure that intl date formatting locales are loaded
      initializeDateFormatting().then((_) {
        // Fire and forget non-critical background services
        _initializeBackgroundServices();

      runApp(
        ProviderScope(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => TransactionProvider()..loadData(),
              ),
              ChangeNotifierProvider(
                create: (_) => ProfileProvider()..loadProfileData(),
              ),
              ChangeNotifierProvider(
                create: (_) => LocaleProvider()..loadLocale(),
              ),
              ChangeNotifierProvider(create: (_) => NavigationProvider()),
              ChangeNotifierProvider(create: (_) => CurrencyProvider()..init()),
              ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
              ChangeNotifierProvider(
                create: (_) => ThemeProvider()..loadTheme(),
              ),
              ChangeNotifierProxyProvider2<
                TransactionProvider,
                SubscriptionProvider,
                GoalsProvider
              >(
                create: (context) => GoalsProvider(),
                update: (context, txProv, subProv, goalsProv) {
                  if (goalsProv == null) return GoalsProvider();

                  // Calculate total fixed expenses
                  double totalSubs = 0.0;
                  for (var sub in subProv.subscriptions) {
                    totalSubs += double.tryParse(sub.price) ?? 0.0;
                  }

                  goalsProv.updateDependencies(
                    txProvider: txProv,
                    subProvider: subProv,
                    income: txProv.salary,
                    expenses: totalSubs,
                  );

                  return goalsProv;
                },
              ),
            ],
            child: const DailyHealthApp(),
          ),
        ),
      );
      });
    },
    (error, stackTrace) {
      debugPrint('Fatal Boot Error: $error');
    },
  );
}

void _initializeBackgroundServices() {
  unawaited(
    Future(() async {
      try {
        // Initialize notification service and schedule daily notifications
        final notifService = NotificationService();
        await notifService.initialize();
        await notifService.scheduleAllDailyNotifications();
        await notifService.scheduleDailyReminderNotification();
        debugPrint('[main] Notification service initialized and scheduled.');
      } catch (e) {
        debugPrint('Background init failed: $e');
      }
    }),
  );
}

class DailyHealthApp extends StatefulWidget {
  const DailyHealthApp({super.key});

  @override
  State<DailyHealthApp> createState() => _DailyHealthAppState();
}

class _DailyHealthAppState extends State<DailyHealthApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeIndex = themeProvider.themeIndex;

    // 0: Light Theme
    final lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF6F8F7),
      cardColor: Colors.white,
      canvasColor: const Color(0xFFF0F4F2), // Light grey for inputs/icons
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2BEE79),
        primary: const Color(0xFF2BEE79), // The brand green color
        onPrimary: const Color(
          0xFF112117,
        ), // Dark text/icons on the green buttons
        tertiary: Colors.orange, // Warning color
        error: Colors.red, // Error/Critical color
        brightness: Brightness.light,
        surface: const Color(0xFFF6F8F7),
        onSurface: Colors.black87,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF0E1B13)),
        bodyMedium: TextStyle(color: Color(0xFF0E1B13)),
      ),
    );

    // 1: Dark Green Theme
    final darkGreenTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF112117), // Deep Green/Black
      cardColor: const Color(0xFF1A2C22), // Slightly lighter surface
      canvasColor: const Color(
        0xFF2A3D32,
      ), // Darker grey/green for inputs/icons
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF30E87A),
        primary: const Color(0xFF30E87A),
        onPrimary: const Color(0xFF112117),
        tertiary: Colors.orange,
        error: Colors.red,
        brightness: Brightness.dark,
        surface: const Color(0xFF1A2C22),
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );

    // 2: Profile Dark Theme (Gece Mavisi)
    final profileDarkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B1121), // En arka plan en koyu
      cardColor: const Color.fromARGB(
        255,
        22,
        34,
        56,
      ), // Kartlar arka plandan daha açık
      canvasColor: const Color(0xFF1E2D4A), // Girdi alanları bir tık daha açık
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0EA5E9), // Sky Blue
        primary: const Color(0xFF0EA5E9),
        onPrimary: Colors.white,
        tertiary: const Color.fromARGB(255, 40, 103, 212),
        error: const Color.fromARGB(255, 17, 63, 143),
        brightness: Brightness.dark,
        surface: const Color(0xFF162238),
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );

    // 3: Amoled Black Theme
    final amoledBlackTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      canvasColor: const Color(0xFF333333),
      dividerColor: const Color(0xFF333333),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(
          0xFF30E87A,
        ), // keeping neon green accent for contrast
        primary: const Color(0xFF30E87A),
        onPrimary: const Color(0xFF121212),
        tertiary: Colors.orange,
        error: Colors.red,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );

    // 4: Pamukşeker (Cotton Candy) Theme
    final cottonCandyTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFFF9FB), // background-light
      cardColor: const Color(0xFFFFFFFF), // surface-light
      canvasColor: const Color(
        0xFFFFF0F5,
      ), // Lighter pink for input backgrounds
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFF8BBD0),
        primary: const Color(0xFFF8BBD0), // primary
        onPrimary: const Color(0xFF880E4F), // dark text on pink
        tertiary: const Color(0xFFF06292), // Darker pink (warning)
        error: const Color(0xFFE91E63), // Pinkish red (critical)
        brightness: Brightness.light,
        surface: const Color(0xFFFFFFFF),
        onSurface: const Color(0xFF1A1617), // background-dark for text
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF1A1617)),
        bodyMedium: TextStyle(color: Color(0xFF1A1617)),
      ),
    );

    // 5: Günbatımı (Sunset) Theme
    final sunsetTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(
        0xFF261A1D,
      ), // Deep dark sunset plum/brown
      cardColor: const Color(0xFF332326), // Surface color
      canvasColor: const Color(0xFF3D2A2E), // Input elements
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFFC107),
        primary: const Color(0xFFFFC107), // Amber
        onPrimary: const Color(0xFF261A1D), // Dark on amber
        tertiary: const Color(0xFFFF9800), // Deep Orange (warning)
        error: const Color(0xFFF44336), // Red (critical)
        brightness: Brightness.dark,
        surface: const Color(0xFF332326),
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );

    ThemeData activeTheme;
    switch (themeIndex) {
      case 0:
        activeTheme = lightTheme;
        break;
      case 1:
        activeTheme = darkGreenTheme;
        break;
      case 2:
        activeTheme = profileDarkTheme;
        break;
      case 3:
        activeTheme = amoledBlackTheme;
        break;
      case 4:
        activeTheme = cottonCandyTheme;
        break;
      case 5:
        activeTheme = sunsetTheme;
        break;
      default:
        activeTheme = lightTheme;
    }

    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,

      title: 'Pretio',

      // Localization
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      theme: activeTheme,
      home: BootScreen(),
    );
  }
}
