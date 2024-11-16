import 'package:flutter/material.dart';
import 'package:quick_attend/screens/admin%20side/admin_change_password.dart';
import 'package:quick_attend/screens/admin%20side/admin_myprofile.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

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
              "Hello World! I am",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Admin",
              style: TextStyle(fontSize: 14, color: Colors.grey),
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
                      // Navigate to ProfilePage when "My Profile" is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ProfilePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("Change Password"),
                    onTap: () {
                      // Navigate to UpdateProfilePage when "Change Password" is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  UpdateProfilePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text("Add Course"),
                    onTap: () {
                      // Navigate to Add Course Screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                    onTap: () {
                      // Handle Logout
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
