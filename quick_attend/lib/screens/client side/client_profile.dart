// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:quick_attend/screens/client%20side/enroll_course.dart';
// import 'package:quick_attend/screens/admin%20side/admin_change_password.dart';
// import 'package:quick_attend/screens/admin%20side/admin_login.dart';
// import 'package:quick_attend/screens/admin%20side/admin_myprofile.dart';

// class ClientprofileScreen extends StatefulWidget {
//   final String enroll_no;

//   const ClientprofileScreen({Key? key, required this.enroll_no})
//       : super(key: key);

//   @override
//   _ClientprofileScreenState createState() => _ClientprofileScreenState();
// }

// class _ClientprofileScreenState extends State<ClientprofileScreen> {
//   String userName = 'Hello World';
//   late String enrollNo; // Enrollment number passed as a parameter
//   int _selectedIndex = 0; // To track the selected bottom navigation item
//   late PageController _pageController; // PageController to control pages

//   @override
//   void initState() {
//     super.initState();
//     enrollNo = widget.enroll_no; // Initialize enrollNo with the passed value
//     fetchUser();
//     _pageController = PageController();
//   }

//   Future<void> fetchUser() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = prefs.getString('User_Name') ?? 'Guest';
//     });
//   }

//   // Handle page navigation when bottom navigation item is selected
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     // Navigate to corresponding page based on the selected index
//     _pageController.jumpToPage(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: PageView(
//           controller: _pageController,
//           onPageChanged: (index) {
//             setState(() {
//               _selectedIndex = index;
//             });
//           },
//           children: [
//             // Home Screen
//             buildProfileScreen(),
//             // My Profile Screen
//             ProfilePage(),
//             // Enroll Course Screen
//             EnrollCoursePage(enrollNo: enrollNo),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add),
//             label: 'Enroll',
//           ),
//         ],
//       ),
//     );
//   }

//   // Profile Screen where the user's profile and menu options are displayed
//   Widget buildProfileScreen() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Profile Section
//         const SizedBox(height: 20),
//         CircleAvatar(
//           radius: 40,
//           backgroundColor: Colors.grey[300],
//           child: const Icon(
//             Icons.person,
//             size: 40,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 12),
//         const Text(
//           "Hello!",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           userName,
//           style: const TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 24),

//         // Menu Options
//         Expanded(
//           child: ListView(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.person),
//                 title: const Text("My Profile"),
//                 onTap: () {
//                   // Navigate to My Profile Screen
//                   setState(() {
//                     _selectedIndex = 1; // Set index to Profile tab
//                   });
//                   _pageController.jumpToPage(1); // Go to Profile page
//                 },
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.lock),
//                 title: const Text("Change Password"),
//                 onTap: () {
//                   // Navigate to Change Password Screen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => UpdateProfilePage(),
//                     ),
//                   );
//                 },
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.add),
//                 title: const Text("Enroll Course"),
//                 onTap: () {
//                   // Pass enrollment number to EnrollCoursePage
//                   setState(() {
//                     _selectedIndex = 2; // Set index to Enroll tab
//                   });
//                   _pageController.jumpToPage(2); // Go to Enroll Course page
//                 },
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.logout),
//                 title: const Text("Logout"),
//                 onTap: () async {
//                   // Handle Logout
//                   final SharedPreferences prefs =
//                       await SharedPreferences.getInstance();
//                   await prefs.setString('User_Name', '');
//                   await prefs.setString('Password', '');
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AdminLoginScreen(),
//                     ),
//                     (Route<dynamic> route) => false,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quick_attend/screens/client%20side/client_change_password.dart';
import 'package:quick_attend/screens/client%20side/client_my_profile.dart';
import 'package:quick_attend/screens/client%20side/enroll_course.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1BC5BD),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ClientProfileScreen(),
    );
  }
}

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Profile Avatar and Name Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFF1BC5BD),
                        child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hello World! I am ........',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Student',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Menu Items
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {
                    // Navigate to StudentProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentProfilePage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'CHANGE PASSWORD',
                  onTap: () {
                    // Navigate to StudentProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.add,
                  title: 'ADD Course',
                  //EnrollCoursePage
                  onTap: () {
                    // Navigate to StudentProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnrollCoursePage(enrollNo: '',),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'LOGOUT',
                  onTap: () {},
                ),
              ],
            ),
          ),

          // // Bottom Navigation Bar
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border(top: BorderSide(color: Colors.grey[300]!)),
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 12),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         _buildBottomNavItem(Icons.home, 'Home', true),
          //         _buildBottomNavItem(Icons.description, 'Report', false),
          //         _buildBottomNavItem(Icons.calendar_today, 'Schedule', false),
          //         _buildBottomNavItem(Icons.person, 'Profile', false),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF1BC5BD) : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF1BC5BD) : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
