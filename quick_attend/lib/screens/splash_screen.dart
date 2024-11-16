import 'package:flutter/material.dart';
import 'package:quick_attend/screens/admin%20side/admin_home_screen.dart';
import 'package:quick_attend/screens/role_distibution.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userName = prefs.getString('User_Name') ?? '';

      if (userName == '') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RoleSelectionScreen())
        ); // Navigate to login screen
      }

      else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminHomeScreen())
        );
      } // Navigate to home screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Image.asset('assets/Images/Logo.jpg'), // Display splash image
      ),
    );
  }
}
