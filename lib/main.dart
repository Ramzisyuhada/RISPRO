import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rispro/data/vendor_data.dart';
import 'package:rispro/screens/about_screen.dart';
import 'package:rispro/screens/intro_screen.dart';
import 'package:rispro/screens/materi_screen.dart';
import 'package:rispro/screens/quiz_screen.dart';
import 'package:rispro/screens/scene2_screen.dart';
import 'package:rispro/screens/scene3_screen.dart';
import 'package:rispro/screens/scene4_screen.dart';
import 'package:rispro/screens/scene5_screen.dart';
import 'package:rispro/screens/scene6_screen.dart';
import 'package:rispro/screens/scene7_screen.dart';
import 'package:rispro/screens/scene8_screen.dart';

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

  initialRoute: '/',

  onGenerateRoute: (settings) {
    switch (settings.name) {

      case '/':
        return MaterialPageRoute(builder: (_) => const MenuScreen());

      case '/materi':
        return MaterialPageRoute(builder: (_) => const MateriScreen());

      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      case '/quiz':
        return MaterialPageRoute(builder: (_) => const QuizScreen());

      case '/game':
        return MaterialPageRoute(builder: (_) => const SimulationIntroScreen());

      /// 🔥 SCENE 2 (TERIMA VENDOR)
      case '/scene2':
        final vendor = settings.arguments as VendorData;
        return MaterialPageRoute(
          builder: (_) => Scene2Screen(vendor: vendor),
        );

      /// 🔥 SCENE 3
      case '/scene3':
        final vendor = settings.arguments as VendorData;
        return MaterialPageRoute(
          builder: (_) => Scene3Screen(vendor: vendor),
        );

case '/scene4':
  final args = settings.arguments as Map;

  return MaterialPageRoute(
    builder: (_) => Scene4Screen(
      vendor: args["vendor"],
      lastChoice: args["lastChoice"],
      impact: args["impact"],
    ),
  );

   case '/scene5':
  final args = settings.arguments as Map;

  return MaterialPageRoute(
    builder: (_) => Scene5Screen(
      vendor: args["vendor"],
      prevImpact: args["prevImpact"],
    ),
  );

      case '/scene6':
  final args = settings.arguments as Map;

  return MaterialPageRoute(
    builder: (_) => Scene6Screen(
      total: args["total"],
    ),
  );case '/scene7':
  final args = (settings.arguments ?? {}) as Map;

  return MaterialPageRoute(
    builder: (_) => Scene7Screen(
      total: args["total"] ?? {},
    ),
  );

      case '/scene8':
        return MaterialPageRoute(builder: (_) => const Scene8Screen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  },
);;
  }
}