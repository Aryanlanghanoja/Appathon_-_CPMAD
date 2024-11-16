class Student {
  // Properties
  final int enrollmentNo; // Enrollment_No (required and non-null)
  final List<String> enrolledCourses; // Array of enrolled courses
  final String email; // Email
  final String phoneNo; // Phone_No
  final String name; // Name
  final String password; // Password
  final String studyClass; // Class of study
  final String labBatch; // Lab batch

  // Constructor with required parameters
  Student({
    required this.enrollmentNo, // Required and non-null
    required this.enrolledCourses,
    required this.email,
    required this.phoneNo,
    required this.name,
    required this.password,
    required this.studyClass,
    required this.labBatch,
  });

  // Method to convert object to JSON (useful for Firebase or APIs)
  Map<String, dynamic> toJson() {
    return {
      'Enrollment_No': enrollmentNo,
      'Enrolled_Courses': enrolledCourses,
      'Email': email,
      'Phone_No': phoneNo,
      'Name': name,
      'Password': password,
      'Study_Class': studyClass,
      'Lab_Batch': labBatch,
    };
  }

  // Method to create an object from JSON (useful for Firebase or APIs)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      enrollmentNo: json['Enrollment_No'] as int, // Explicitly required
      enrolledCourses: List<String>.from(
          json['Enrolled_Courses']), // Convert to List<String>
      email: json['Email'] as String,
      phoneNo: json['Phone_No'] as String,
      name: json['Name'] as String,
      password: json['Password'] as String,
      studyClass: json['Study_Class'] as String,
      labBatch: json['Lab_Batch'] as String,
    );
  }
}
