import 'package:flutter/material.dart'; // Required for TimeOfDay

class ClassSession {
  // Properties
  final String className; // Class name
  final String subject; // Subject name
  final String batchName; // Batch name
  final DateTime date; // Date of the session
  final String location; // Location of the class
  final int numberOfStudents; // Number of students
  final TimeOfDay startTime; // Start time
  final TimeOfDay endTime; // End time
  final bool attendanceTaken; // Attendance status
  final int classId; // Unique class ID

  // Constructor with required fields
  ClassSession({
    required this.className,
    required this.subject,
    required this.batchName,
    required this.date,
    required this.location,
    required this.numberOfStudents,
    required this.startTime,
    required this.endTime,
    required this.attendanceTaken,
    required this.classId,
  });

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Class_Name': className,
      'Subject': subject,
      'Batch_Name': batchName,
      'Date': date.toIso8601String(),
      'Location': location,
      'Number_Of_Students': numberOfStudents,
      'Start_Time': _formatTime(startTime),
      'End_Time': _formatTime(endTime),
      'Attendance_Taken': attendanceTaken,
      'Class_ID': classId,
    };
  }

  // Create an object from JSON
  factory ClassSession.fromJson(Map<String, dynamic> json) {
    return ClassSession(
      className: json['Class_Name'] as String,
      subject: json['Subject'] as String,
      batchName: json['Batch_Name'] as String,
      date: DateTime.parse(json['Date']),
      location: json['Location'] as String,
      numberOfStudents: json['Number_Of_Students'] as int,
      startTime: _parseTime(json['Start_Time']),
      endTime: _parseTime(json['End_Time']),
      attendanceTaken: json['Attendance_Taken'] as bool,
      classId: json['Class_ID'] as int,
    );
  }

  // Helper method to parse time in HH:mm format to TimeOfDay
  static TimeOfDay _parseTime(String? timeString) {
    try {
      final parts = timeString?.split(':') ?? [];
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      // Handle error gracefully and return a default value (e.g., midnight)
      return TimeOfDay(hour: 0, minute: 0);
    }
    // Return default value if parsing fails
    return TimeOfDay(hour: 0, minute: 0);
  }

  // Helper method to format TimeOfDay into HH:mm
  static String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
