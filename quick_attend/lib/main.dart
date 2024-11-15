import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_attend/firebase_options.dart';
import 'package:quick_attend/screens/client%20side/client_registration.dart';
import 'package:quick_attend/screens/role_distibution.dart';
// import 'package:quick_attend/screens/home_screen.dart';
import 'package:quick_attend/screens/splash_screen.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Attend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
          routes: {
        '/home': (context) => const RegistrationScreen(), // Define your home screen here
      },
    );
  }
}
