import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_attend/firebase_options.dart';
import 'package:quick_attend/screens/role_distibution.dart';
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
        scaffoldBackgroundColor: Colors.white, // Set base background to white
        appBarTheme: const AppBarTheme(
          color: Colors.white, // Set AppBar background to white
          iconTheme: IconThemeData(color: Colors.black), // Set icons to black
          titleTextStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor:
                Colors.teal), // Optional, you can adjust to your color scheme
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(color: Colors.black), // Set default text color to black
          bodyMedium: TextStyle(color: Colors.black),
        ),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.teal),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const RoleSelectionScreen(),
      },
    );
  }
}
