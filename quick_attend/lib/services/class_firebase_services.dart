import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_attend/model/classes.dart';

class FirebaseServices {
  var db = FirebaseFirestore.instance;

  // Add a new class session
  addClassSession(ClassSession classSession) {
    // Create a new class session document
    final classSessionData =
        classSession.toJson(); // Use the toJson() method of ClassSession model

    // Add a new document with a generated ID
    db.collection("class").add(classSessionData).then((DocumentReference doc) =>
        // ignore: avoid_print
        print('Class session added with ID: ${doc.id}'));
  }

  // Fetch all class sessions
  Stream<QuerySnapshot> fetchClassSessions() {
    Stream<QuerySnapshot> collectionStream =
        FirebaseFirestore.instance.collection('class').snapshots();
    return collectionStream;
  }

  // Update a class session
  updateClassSession(ClassSession classSession) {
    return db
        .collection("class")
        .doc(classSession.classId
            .toString()) // Assuming classId is used as document ID
        .update(classSession
            .toJson()) // Convert ClassSession object to JSON for updating
        // ignore: avoid_print
        .then((value) => print("Class session updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update class session: $error"));
  }

  // Delete a class session by classId
  deleteClassSession(int classId) {
    return db
        .collection("class")
        .doc(classId.toString()) // Assuming classId is used as document ID
        .delete()
        // ignore: avoid_print
        .then((value) => print("Class session deleted"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to delete class session: $error"));
  }
}
