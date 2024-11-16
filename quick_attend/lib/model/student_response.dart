import 'package:flutter/material.dart';

class StudentResponse {
  // Properties
  final String name; // Student's name
  final String enrollmentNo; // Enrollment number
  final String locationCoordinates; // Location coordinates (e.g., "lat,long")
  final TimeOfDay time; // Time of the response
  final String course; // Course name
  final String studentClass; // Class name
  final String batch; // Batch name
  final int responseId; // Unique response ID

  // Constructor with required fields
  StudentResponse({
    required this.name,
    required this.enrollmentNo,
    required this.locationCoordinates,
    required this.time,
    required this.course,
    required this.studentClass,
    required this.batch,
    required this.responseId,
  });

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Enrollment_No': enrollmentNo,
      'Location_Coordinates': locationCoordinates,
      'Time': '${time.hour}:${time.minute}', // Format time as HH:mm
      'Course': course,
      'Class': studentClass,
      'Batch': batch,
      'Response_ID': responseId,
    };
  }

  // Create an object from JSON
  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    return StudentResponse(
      name: json['Name'] as String,
      enrollmentNo: json['Enrollment_No'] as String,
      locationCoordinates: json['Location_Coordinates'] as String,
      time: _parseTime(json['Time']),
      course: json['Course'] as String,
      studentClass: json['Class'] as String,
      batch: json['Batch'] as String,
      responseId: json['Response_ID'] as int,
    );
  }

  // Helper method to parse time in HH:mm format to TimeOfDay
  static TimeOfDay _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      // Return default value if parsing fails
      return TimeOfDay(hour: 0, minute: 0);
    }
  }
}
