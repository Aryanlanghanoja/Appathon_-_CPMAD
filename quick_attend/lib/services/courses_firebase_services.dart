import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_attend/model/courses.dart';

class FirebaseServices {
  var db = FirebaseFirestore.instance;

  // Add a new course
  addCourse(Course course) {
    // Create a new course document
    final courseData =
        course.toJson(); // Use the toJson() method of Course model

    // Add a new document with a generated ID
    db.collection("courses").add(courseData).then(
        (DocumentReference doc) => print('Course added with ID: ${doc.id}'));
  }

  // Fetch all courses
  Stream<QuerySnapshot> fetchCourses() {
    Stream<QuerySnapshot> collectionStream =
        FirebaseFirestore.instance.collection('courses').snapshots();
    return collectionStream;
  }

  // Update a course
  updateCourse(Course course) {
    return db
        .collection("courses")
        .doc(course.courseId
            .toString()) // Assuming courseId is used as document ID
        .update(course.toJson()) // Convert Course object to JSON for updating
        .then((value) => print("Course updated"))
        .catchError((error) => print("Failed to update course: $error"));
  }

  // Delete a course by courseId
  deleteCourse(int courseId) {
    return db
        .collection("courses")
        .doc(courseId.toString()) // Assuming courseId is used as document ID
        .delete()
        .then((value) => print("Course deleted"))
        .catchError((error) => print("Failed to delete course: $error"));
  }
}
