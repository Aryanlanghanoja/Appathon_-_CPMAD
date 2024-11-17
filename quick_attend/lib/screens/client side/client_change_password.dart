// import 'package:flutter/material.dart';
// import 'package:quick_attend/screens/admin%20side/admin_profile.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: UpdateProfilePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class UpdateProfilePage extends StatelessWidget {
//   const UpdateProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               // ignore: use_build_context_synchronously
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const AdminProfileScreen(),
//               ),
//             );
//           },
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 20),
//           CircleAvatar(
//             radius: 40,
//             backgroundColor: Colors.grey.shade200,
//             child: Icon(
//               Icons.person,
//               size: 40,
//               color: Colors.teal,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             "Hello World! I am .........",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             "Admin",
//             style: TextStyle(color: Colors.grey),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: [
//                 PasswordField(label: 'Password'),
//                 SizedBox(height: 15),
//                 PasswordField(label: 'Confirm Password'),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Update button logic
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.teal,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//             ),
//             child: Text(
//               'Update',
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.assessment), label: 'Report'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.schedule), label: 'Schedule'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }

// class PasswordField extends StatelessWidget {
//   final String label;

//   const PasswordField({super.key, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFFD9D9D9), // Background color for the password box
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         obscureText: true,
//         decoration: InputDecoration(
//           hintText: label,
//           border: OutlineInputBorder(
//             borderSide: BorderSide.none,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           suffixIcon: Icon(Icons.visibility),
//           contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text('Change Password'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Current Password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {}, // Implement password visibility toggle
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {}, // Implement password visibility toggle
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {}, // Implement password visibility toggle
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {}, // Implement change password action
              child: Text('Change Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
