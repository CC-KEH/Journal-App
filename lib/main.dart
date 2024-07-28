import 'package:flutter/material.dart';
import 'package:journal/screens/home/home_screen.dart';
import 'package:journal/notifications.dart';
import 'package:journal/theme_notifier.dart';
import 'package:journal/notifiers/settings_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureTimeZone();
  initializeNotifications();
  scheduleNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: themeNotifier.currentTheme,
      navigatorObservers: [routeObserver],
      home: const HomeScreen(),
    );
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();