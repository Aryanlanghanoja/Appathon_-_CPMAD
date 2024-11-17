import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_attend/screens/admin%20side/admin_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  int enrollmentNo =
      1111; // Default value, this will be replaced by the value from SharedPreferences.

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Fetching 'Enrollemt_No' from SharedPreferences as a string and converting it to int.
      enrollmentNo =
          int.tryParse(prefs.getString('Enrollemt_No') ?? '0000') ?? 0000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminProfileScreen(),
              ),
            );
          }, // Navigate back
        ),
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('client_login')
            .doc(enrollmentNo
                .toString()) // Using the enrollmentNo fetched from SharedPreferences.
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Hello World! I am ${userData['name']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Student",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ProfileInfoRow(label: 'Name', value: userData['name']),
                    ProfileInfoRow(
                        label: 'Enrollment No',
                        value: userData['enrollmentNo'].toString()),
                    ProfileInfoRow(label: 'Mobile', value: userData['phoneNo']),
                    ProfileInfoRow(label: 'Email Id', value: userData['email']),
                    ProfileInfoRow(
                        label: 'Gender',
                        value: userData['gender'] ?? 'Not provided'),
                    ProfileInfoRow(
                        label: 'Password',
                        value: userData['password'] ?? 'Not provided'),
                    ProfileInfoRow(
                        label: 'Study Class',
                        value: userData['studyClass'] ?? 'Not provided'),
                    ProfileInfoRow(
                        label: 'Lab Batch',
                        value: userData['labBatch'] ?? 'Not provided'),
                    ProfileInfoRow(
                        label: 'Enrolled Courses',
                        value: userData['enrolledCourses'].join(', ') ??
                            'No courses enrolled'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.assessment), label: 'Report'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.schedule), label: 'Schedule'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      //   selectedItemColor: Colors.teal,
      //   unselectedItemColor: Colors.grey,
      //   type: BottomNavigationBarType.fixed,
      // ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label :',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
