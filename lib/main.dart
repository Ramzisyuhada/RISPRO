import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rispro/screens/about_screen.dart';
import 'package:rispro/screens/intro_screen.dart';
import 'package:rispro/screens/materi_screen.dart';
import 'package:rispro/screens/quiz_screen.dart';
import 'package:rispro/screens/scene2_screen.dart';
import 'package:rispro/screens/scene3_screen.dart';

import 'provider/game_state.dart';
import 'screens/menu_screen.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //create: (_) => GameState(scenarios),
      create: (BuildContext context) { 

       },
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
      ),

      // 🔥 ROUTES
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
       '/materi': (context) => const MateriScreen(),
              '/about': (context) => const AboutScreen(),
              '/quiz': (context) => const QuizScreen(),
                            '/game': (context) => const SimulationIntroScreen(),

                            '/scene2': (context) => const Scene2Screen(),
                            '/scene3': (context) => const Scene3Screen(),

      },
    );
  }
}