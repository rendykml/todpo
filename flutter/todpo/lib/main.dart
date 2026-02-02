import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todpo/features/authentication/screens/onboarding/onboarding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/task/task_controller.dart';
import 'features/stats/stats_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskController()),
        ChangeNotifierProvider(create: (_) => StatsController()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: OnBoardingScreen(),
      title: 'Todpo',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,

          // WARNA UTAMA
          primary: Colors.black,
          onPrimary: Colors.white,

          secondary: Colors.white,
          onSecondary: Colors.black,

          // BACKGROUND
          background: Colors.white,
          onBackground: Colors.black,

          surface: Colors.white,
          onSurface: Colors.black,

          // ERROR
          error: Colors.black,
          onError: Colors.white,
        ),
      ),

      // 🌙 DARK MODE
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
    );
  }
}
