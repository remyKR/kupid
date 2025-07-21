import 'package:flutter/material.dart';
import 'screens/startScreen.dart';
import 'screens/loginEmail.dart';
import 'screens/joinEmail.dart';
import 'screens/signupProfileName.dart';

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
        '/login_email': (context) => const loginEmail(),
        '/join_email': (context) => const JoinEmailScreen(),
        '/signupProfileName': (context) => const SignupProfileNameScreen(),
      },
      home: const StartScreen(),
    );
  }
}
