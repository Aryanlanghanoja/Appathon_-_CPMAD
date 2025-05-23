import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                RoleSelectionScreen())); // Navigate to login screen
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AdminHomeScreen(
                  facultyNo: '',
                )));
      } // Navigate to home screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            Positioned(
              // bottom: 50, // Place logo at the bottom
              child: Image.asset(
                'assets/Images/Logo.jpg',
                // width: 150, // Adjust the width
                // height: 150, // Adjust the height
                // fit: BoxFit.contain,
              ),
            ),
            // Lottie animation with defined size
            Lottie.asset(
              "assets/animation/loader.json",
              width: 200, // Adjust the width
              height: 200, // Adjust the height
              fit: BoxFit.contain, // Ensure it fits within its bounds
            ),

            // Logo with defined size and position

          ],
        ),
      ),
    );
  }
}
