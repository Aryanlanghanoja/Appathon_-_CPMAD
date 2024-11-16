import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_attend/model/student_response.dart';

class FirebaseServices {
  var db = FirebaseFirestore.instance;

  // Add a new student response
  addStudentResponse(StudentResponse studentResponse) {
    // Create a new student response document
    final studentResponseData = studentResponse
        .toJson(); // Use the toJson() method of StudentResponse model

    // Add a new document with a generated ID
    db.collection("student_response").add(studentResponseData).then(
        (DocumentReference doc) =>
            // ignore: avoid_print
            print('Student Response added with ID: ${doc.id}'));
  }

  // Fetch all student responses
  Stream<QuerySnapshot> fetchStudentResponses() {
    Stream<QuerySnapshot> collectionStream =
        FirebaseFirestore.instance.collection('student_response').snapshots();
    return collectionStream;
  }

  // Update a student response
  updateStudentResponse(StudentResponse studentResponse) {
    return db
        .collection("student_response")
        .doc(studentResponse.responseId
            .toString()) // Assuming responseId is used as document ID
        .update(studentResponse
            .toJson()) // Convert StudentResponse object to JSON for updating
        // ignore: avoid_print
        .then((value) => print("Student Response updated"))
        .catchError(
            // ignore: avoid_print
            (error) => print("Failed to update student response: $error"));
  }

  // Delete a student response by responseId
  deleteStudentResponse(int responseId) {
    return db
        .collection("student_response")
        .doc(
            responseId.toString()) // Assuming responseId is used as document ID
        .delete()
        // ignore: avoid_print
        .then((value) => print("Student Response deleted"))
        .catchError(
            // ignore: avoid_print
            (error) => print("Failed to delete student response: $error"));
  }
}
