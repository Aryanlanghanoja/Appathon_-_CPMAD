class Faculty {
  // Properties
  // ignore: non_constant_identifier_names
  final int faculty_No; // Faculty_No (required and non-null)
  final List<String> courses; // Array of courses
  final String email; // Email
  final String phoneNo; // Phone_No
  final String name; // Name
  final String password; // Password

  // Constructor with required parameters
  Faculty({
    // ignore: non_constant_identifier_names
    required this.faculty_No, // Required and non-null
    required this.courses,
    required this.email,
    required this.phoneNo,
    required this.name,
    required this.password,
  });

  // Method to convert object to JSON (useful for Firebase or APIs)
  Map<String, dynamic> toJson() {
    return {
      'Faculty_No': faculty_No,
      'Courses': courses,
      'Email': email,
      'Phone_No': phoneNo,
      'Name': name,
      'Password': password,
    };
  }

  // Method to create an object from JSON (useful for Firebase or APIs)
  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      faculty_No: json['Faculty_No'] as int, // Must be explicitly provided
      courses: List<String>.from(json['Courses']), // Convert to List<String>
      email: json['Email'] as String,
      phoneNo: json['Phone_No'] as String,
      name: json['Name'] as String,
      password: json['Password'] as String,
    );
  }
}
