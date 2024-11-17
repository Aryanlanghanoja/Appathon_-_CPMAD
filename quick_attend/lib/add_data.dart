import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddDataPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddDataPage extends StatelessWidget {
  final List<Map<String, dynamic>> dummyData = [
    {"class": "1tk1", "class_id": 1, "course_name": "maths"},
    {"class": "1tk2", "class_id": 2, "course_name": "science"},
    {"class": "1tk3", "class_id": 3, "course_name": "english"},
    {"class": "2tk1", "class_id": 4, "course_name": "history"},
    {"class": "2tk2", "class_id": 5, "course_name": "geography"},
    {"class": "2tk3", "class_id": 6, "course_name": "physics"},
    {"class": "3tk1", "class_id": 7, "course_name": "chemistry"},
    {"class": "3tk2", "class_id": 8, "course_name": "biology"},
    {"class": "3tk3", "class_id": 9, "course_name": "computer science"},
    {"class": "4tk1", "class_id": 10, "course_name": "economics"},
  ];

  Future<void> addDataToFirestore() async {
    final CollectionReference courses = FirebaseFirestore.instance.collection('courses');

    for (var entry in dummyData) {
      await courses.add(entry);
    }

    print("Dummy data added successfully!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Data to Firestore"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await addDataToFirestore();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Data added to Firestore!")),
            );
          },
          child: Text("Add Dummy Data"),
        ),
      ),
    );
  }
}
