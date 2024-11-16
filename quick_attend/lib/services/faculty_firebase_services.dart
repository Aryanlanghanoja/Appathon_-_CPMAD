import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_attend/model/faculty_profile.dart';

class FirebaseServices {
  var db = FirebaseFirestore.instance;

  // Add a new faculty profile
  addFaculty(Faculty faculty) {
    // Create a new faculty document
    final facultyData =
        faculty.toJson(); // Use the toJson() method of Faculty model

    // Add a new document with a generated ID
    db.collection("faculty_profile").add(facultyData).then(
        (DocumentReference doc) =>
            print('Faculty profile added with ID: ${doc.id}'));
  }

  // Fetch all faculty profiles
  Stream<QuerySnapshot> fetchFacultyProfiles() {
    Stream<QuerySnapshot> collectionStream =
        FirebaseFirestore.instance.collection('faculty_profile').snapshots();
    return collectionStream;
  }

  // Update a faculty profile
  updateFaculty(Faculty faculty) {
    return db
        .collection("faculty_profile")
        .doc(faculty.faculty_No
            .toString()) // Assuming faculty_No is used as document ID
        .update(faculty.toJson()) // Convert Faculty object to JSON for updating
        .then((value) => print("Faculty profile updated"))
        .catchError(
            (error) => print("Failed to update faculty profile: $error"));
  }

  // Delete a faculty profile by faculty_No
  deleteFaculty(int faculty_No) {
    return db
        .collection("faculty_profile")
        .doc(
            faculty_No.toString()) // Assuming faculty_No is used as document ID
        .delete()
        .then((value) => print("Faculty profile deleted"))
        .catchError(
            (error) => print("Failed to delete faculty profile: $error"));
  }
}
