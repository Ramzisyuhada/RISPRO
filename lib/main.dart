import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/vendor_data.dart';
import 'screens/about_screen.dart';
import 'screens/certificate_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/materi_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/scene2_screen.dart';
import 'screens/scene3_screen.dart';
import 'screens/scene4_screen.dart';
import 'screens/scene5_screen.dart';
import 'screens/scene6_screen.dart';
import 'screens/scene7_screen.dart';
import 'screens/scene8_screen.dart';
import 'theme/rispro_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    ///url: 'https://jptvtjxyjsacuvumtgsv.supabase.co',
    //anonKey: 'sb_publishable_9PRhZ4BPjtvd3lpetBVt3w_ONZ__3wU',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RISPRO - Risk Decision Simulator',
      debugShowCheckedModeBanner: false,
      theme: RisproTheme.lightTheme,
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
            return MaterialPageRoute(
              builder: (_) => const SimulationIntroScreen(),
            );

          /// 🔥 SCENE 2 (KLASIFIKASI RISIKO)
          case '/scene2':
            final vendor = settings.arguments as VendorData;
            return MaterialPageRoute(
              builder: (_) => Scene2Screen(vendor: vendor),
            );

          /// 🔥 SCENE 3 (CERTAINTY)
          case '/scene3':
            final vendor = settings.arguments as VendorData;
            return MaterialPageRoute(
              builder: (_) => Scene3Screen(vendor: vendor),
            );

          /// 🔥 SCENE 4 (RISK)
          case '/scene4':
            final args = settings.arguments as Map;
            return MaterialPageRoute(
              builder: (_) => Scene4Screen(
                vendor: args["vendor"],
                lastChoice: args["lastChoice"],
                impact: args["impact"],
              ),
            );

          /// 🔥 SCENE 5 (UNCERTAINTY)
          case '/scene5':
            final args = settings.arguments as Map;
            return MaterialPageRoute(
              builder: (_) => Scene5Screen(
                vendor: args["vendor"],
                prevImpact: args["prevImpact"],
              ),
            );

          /// 🔥 SCENE 6 (EVALUASI AKHIR)
          case '/scene6':
            final args = settings.arguments as Map;
            return MaterialPageRoute(
              builder: (_) => Scene6Screen(total: args["total"]),
            );

          /// 🔥 SCENE 7 (ANALISIS PROFIL RISIKO)
          case '/scene7':
            final args = (settings.arguments ?? {}) as Map;
            return MaterialPageRoute(
              builder: (_) => Scene7Screen(total: args["total"] ?? {}),
            );

          /// 🔥 SCENE 8 (REFLEKSI)
          case '/scene8':
            return MaterialPageRoute(builder: (_) => const Scene8Screen());

          /// 🔥 CERTIFICATE
          case '/certificate':
            final args = settings.arguments;
            final data = args is Map
                ? Map<String, dynamic>.from(args)
                : const <String, dynamic>{};
            return MaterialPageRoute(
              builder: (_) => CertificateScreen(data: data),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("Route not found")),
              ),
            );
        }
      },
    );
  }
}
