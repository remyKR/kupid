import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'screens/discover.dart';
import 'screens/startScreen.dart';
import 'screens/loginEmail.dart';
import 'screens/joinEmail.dart';
import 'screens/signupProfileName.dart';
import 'screens/signupBasicInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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
      home: const DiscoverScreen(),
    );
  }
}