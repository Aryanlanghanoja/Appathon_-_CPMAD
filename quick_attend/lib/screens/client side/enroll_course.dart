import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quick_attend/firebase_options.dart';
// Import your Firebase options file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // For demonstration, passing a dummy enroll_no.
    // In your app, replace 'ENR12345' with the actual enroll_no from login.
    return MaterialApp(
      home: EnrollCoursePage(enrollNo: 'ENR12345'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EnrollCoursePage extends StatefulWidget {
  final String enrollNo; // The enroll number from the login screen

  const EnrollCoursePage({super.key, required this.enrollNo});

  @override
  _EnrollCoursePageState createState() => _EnrollCoursePageState();
}

class _EnrollCoursePageState extends State<EnrollCoursePage> {
  List<Map<String, dynamic>> courses = []; // List to store course details
  String? selectedCourseName; // Holds the currently selected course name
  String? selectedCourseId; // Holds the corresponding course ID
  bool isLoading = true; // Loading state while fetching data

  @override
  void initState() {
    super.initState();
    fetchCourses(); // Fetch courses from Firestore
  }

  Future<void> fetchCourses() async {
    try {
      // Fetching the collection 'courses' from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('courses').get();

      // Extracting 'course_name' and 'class_id' from each document
      final fetchedCourses = snapshot.docs.map((doc) {
        return {
          'course_name': doc['course_name'].toString(),
          'class_id': doc['class_id'].toString(),
        };
      }).toList();

      setState(() {
        courses = fetchedCourses;
        isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        isLoading = false;
      });
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch courses. Please try again.')),
      );
    }
  }

  Future<void> enrollInCourse() async {
    if (selectedCourseName == null || selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a course to enroll.')),
      );
      return;
    }

    try {
      // Check if the enrollment document already exists for the student
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('enroll_no', isEqualTo: widget.enrollNo)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Document exists, append the course to the 'course_name' array
        DocumentReference enrollmentDoc = snapshot.docs.first.reference;

        await enrollmentDoc.update({
          'course_name': FieldValue.arrayUnion([selectedCourseName]),
        });
      } else {
        // Document does not exist, create a new enrollment entry
        await FirebaseFirestore.instance.collection('enrollments').add({
          'enroll_no': widget.enrollNo,
          'course_name': [selectedCourseName], // Add as an array
          'course_id': selectedCourseId,
          'enrolled_at': FieldValue.serverTimestamp(),
        });
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully enrolled in $selectedCourseName')),
      );

      // Optionally, reset the form
      setState(() {
        selectedCourseName = null;
        selectedCourseId = null;
      });
    } catch (e) {
      print('Error enrolling in course: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to enroll. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Text('Enroll Course', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader if fetching
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      Icons.book,
                      size: 40,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enroll in a Course",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedCourseName,
                          items: courses.map((course) {
                            return DropdownMenuItem<String>(
                              value: course['course_name'],
                              child: Text(course['course_name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCourseName = value;
                              // Find the corresponding course_id
                              selectedCourseId = courses.firstWhere(
                                  (course) =>
                                      course['course_name'] == value)['class_id'];
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFD9D9D9),
                            hintText: 'Select Course Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                          ),
                        ),
                        SizedBox(height: 15),
                        // If you still need the Course ID field as a display, make it read-only
                        // Otherwise, you can remove this widget
                        CourseField(
                          label: 'Course ID',
                          controller: TextEditingController(
                              text: selectedCourseId ?? ''),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: enrollInCourse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text(
                      'Enroll',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        // Optionally, handle navigation here
      ),
    );
  }
}

class CourseField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;

  const CourseField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9), // Background color for the input box
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly, // Make it read-only if needed
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }
}
