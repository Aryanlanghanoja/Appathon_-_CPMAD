import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quick_attend/screens/client%20side/enroll_course.dart';
import 'package:quick_attend/screens/admin%20side/admin_change_password.dart';
import 'package:quick_attend/screens/admin%20side/admin_login.dart';
import 'package:quick_attend/screens/admin%20side/admin_myprofile.dart';

class ClientprofileScreen extends StatefulWidget {
  final String enroll_no;

  const ClientprofileScreen({Key? key, required this.enroll_no})
      : super(key: key);

  @override
  _ClientprofileScreenState createState() => _ClientprofileScreenState();
}

class _ClientprofileScreenState extends State<ClientprofileScreen> {
  String userName = 'Hello World';
  late String enrollNo; // Enrollment number passed as a parameter

  @override
  void initState() {
    super.initState();
    enrollNo = widget.enroll_no; // Initialize enrollNo with the passed value
    fetchUser();
  }

  Future<void> fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('User_Name') ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Section
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Hello!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              userName,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Menu Options
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("My Profile"),
                    onTap: () {
                      // Navigate to My Profile Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("Change Password"),
                    onTap: () {
                      // Navigate to Change Password Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProfilePage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text("Enroll Course"),
                    onTap: () {
                      // Pass enrollment number to EnrollCoursePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnrollCoursePage(
                            enrollNo: enrollNo,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                    onTap: () async {
                      // Handle Logout
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('User_Name', '');
                      await prefs.setString('Password', '');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminLoginScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
