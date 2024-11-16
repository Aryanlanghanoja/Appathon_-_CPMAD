import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_attend/model/student_profile.dart';

class FirebaseServices {
  var db = FirebaseFirestore.instance;

  // Add a new student profile
  addStudent(Student student) {
    // Create a new student document
    final studentData =
        student.toJson(); // Use the toJson() method of Student model

    // Add a new document with a generated ID
    db.collection("student_profile").add(studentData).then(
        (DocumentReference doc) =>
            // ignore: avoid_print
            print('Student profile added with ID: ${doc.id}'));
  }

  // Fetch all student profiles
  Stream<QuerySnapshot> fetchStudentProfiles() {
    Stream<QuerySnapshot> collectionStream =
        FirebaseFirestore.instance.collection('student_profile').snapshots();
    return collectionStream;
  }

  // Update a student profile
  updateStudent(Student student) {
    return db
        .collection("student_profile")
        .doc(student.enrollmentNo
            .toString()) // Assuming enrollmentNo is used as document ID
        .update(student.toJson()) // Convert Student object to JSON for updating
        // ignore: avoid_print
        .then((value) => print("Student profile updated"))
        .catchError(
            // ignore: avoid_print
            (error) => print("Failed to update student profile: $error"));
  }

  // Delete a student profile by enrollmentNo
  deleteStudent(int enrollmentNo) {
    return db
        .collection("student_profile")
        .doc(enrollmentNo
            .toString()) // Assuming enrollmentNo is used as document ID
        .delete()
        // ignore: avoid_print
        .then((value) => print("Student profile deleted"))
        .catchError(
            // ignore: avoid_print
            (error) => print("Failed to delete student profile: $error"));
  }
}
