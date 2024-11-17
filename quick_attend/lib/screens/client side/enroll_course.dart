import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EnrollCoursePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EnrollCoursePage extends StatefulWidget {
  const EnrollCoursePage({super.key});

  @override
  _EnrollCoursePage createState() => _EnrollCoursePage();
}

class _EnrollCoursePage extends State<EnrollCoursePage> {
  List<String> courseNames = []; // List to store course names
  String? selectedCourse; // Holds the currently selected course
  bool isLoading = true; // Loading state while fetching data

  @override
  void initState() {
    super.initState();
    fetchCourseNames(); // Fetch course names from Firestore
  }

  Future<void> fetchCourseNames() async {
    try {
      // Fetching the collection 'courses' from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('courses').get();

      // Extracting 'course_name' from each document
      final fetchedCourses = snapshot.docs
          .map((doc) => doc['course_name'].toString())
          .toList();

      setState(() {
        courseNames = fetchedCourses;
        isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        isLoading = false;
      });
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
          : Column(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<String>(
                    value: selectedCourse,
                    items: courseNames.map((course) {
                      return DropdownMenuItem<String>(
                        value: course,
                        child: Text(course),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCourse = value; // Update selected course
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCourse != null) {
                      print('Enrolled in: $selectedCourse');
                      // Add logic for course enrollment here
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a course name')),
                      );
                    }
                  },
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
    );
  }
}
