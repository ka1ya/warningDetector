import 'package:flutter/material.dart';
import 'features/detection_page.dart';
import 'features/home_page.dart';
import 'features/loading_page.dart';
import 'features/settings_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  static const String initialRoute = '/';
  static const String loadingPageRoute = '/loading';
  static const String mainPageRoute = '/main';
  static const String settingsPageRoute = '/settings';
  static const String detectionPageRoute = '/detection';
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF15131C),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromRGBO(143, 100, 73, 1),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        initialRoute: (context) => const LoadingPage(), //LoadingPage
        mainPageRoute: (context) => const HomePage(),
        detectionPageRoute: (context) => const SettingsWidget(),
        settingsPageRoute: (context) => const DetectionWidget(),
      },
    );
  }
}
