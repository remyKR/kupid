import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
import 'screens/login_email.dart';
import 'screens/join_email.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kupid',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0E0FF),
        useMaterial3: true,
      ),
      routes: {
        '/login_email': (context) => const login_email(),
        '/join_email': (context) => const JoinEmailScreen(),
      },
      home: const StartScreen(),
    );
  }
}
