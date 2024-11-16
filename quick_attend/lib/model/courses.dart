class Course {
  // Properties
  final String courseName; // Course name
  final String className; // Associated class name
  final int courseId; // Course ID (required and non-null)

  // Constructor with required parameters
  Course({
    required this.courseName,
    required this.className,
    required this.courseId,
  });

  // Method to convert object to JSON (useful for Firebase or APIs)
  Map<String, dynamic> toJson() {
    return {
      'Course_Name': courseName,
      'Class_Name': className,
      'Course_ID': courseId,
    };
  }

  // Method to create an object from JSON (useful for Firebase or APIs)
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseName: json['Course_Name'] as String,
      className: json['Class_Name'] as String,
      courseId: json['Course_ID'] as int,
    );
  }
}
