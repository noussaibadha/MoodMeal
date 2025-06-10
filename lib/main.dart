import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/supabase_service.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/suggestion_screen.dart';
import 'screens/navigation_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodMeal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.josefinSansTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        if (settings.name == '/suggestions') {
          final mood = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => SuggestionsScreen(humeur: mood),
          );
        }
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          case '/wrapper':
            return MaterialPageRoute(builder: (_) => const NavigationWrapper());
          default:
            return null;
        }
      },
    );
  }
}
