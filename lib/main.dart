import 'package:flutter/material.dart';
import 'services/supabase_service.dart';

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
      home: Scaffold(
        body: Center(
          child: Text('MoodMeal est lancé !'),
        ),
      ),
    );
  }
}

