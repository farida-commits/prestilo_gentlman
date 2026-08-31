// main.dart
import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const GentlemanProApp());
}

class GentlemanProApp extends StatelessWidget {
  const GentlemanProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GentlemanPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgMain,
        fontFamily: 'Raleway',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}