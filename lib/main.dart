import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/onboarding_screen.dart';
import 'screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://imbrrrtmtsphkmkhwpow.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImltYnJycnRtdHNwaGtta2h3cG93Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY1MDQ2MTEsImV4cCI6MjA1MjA4MDYxMX0.DdBcnppdkSTnWNK8oPB-Ul-A-nViqR-DGpuI2S8Jw3w',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/start': (context) => StartScreen(),
      },
    );
  }
}
