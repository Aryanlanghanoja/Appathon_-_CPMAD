import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputFormScreen extends StatefulWidget {
  @override
  _InputFormScreenState createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _enrollmentNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _responseIdController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Time field is read-only and auto-populated
  late String _time;

  // Dropdown for courses
  final List<String> _courses = [
    "Mathematics",
    "Physics",
    "Chemistry",
    "Biology",
    "Computer Science"
  ]; // Replace with dynamic course names
  String? _selectedCourse; // Holds the selected course

  @override
  void initState() {
    super.initState();
    _time = DateTime.now().toString();
    _locationController.text = "Fetching location...";
    _getLocationPermissionAndFetchCoordinates();
  }

  Future<void> _getLocationPermissionAndFetchCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _locationController.text = "Location services are disabled.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enable location services.")),
      );
      return;
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _locationController.text = "Location permission denied.";
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _locationController.text = "Location permission permanently denied.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Location permissions are permanently denied. Please allow them from settings."),
        ),
      );
      return;
    }

    // Fetch current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );
      _locationController.text = "${position.latitude}, ${position.longitude}";
    } catch (e) {
      print("Error fetching location: $e");
      _locationController.text = "Error fetching location.";
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "batch": _batchController.text,
        "class": _classController.text,
        "course": _selectedCourse ?? "Not selected",
        "enrollment_no": _enrollmentNoController.text,
        "location": _locationController.text,
        "name": _nameController.text,
        "response_id": _responseIdController.text,
        "time": _time,
      };

      try {
        // Save data to Firestore
        await FirebaseFirestore.instance.collection('formResponses').add(data);
        print("Data saved to Firestore: $data");

        // Clear the form
        _formKey.currentState!.reset();
        _locationController.text = "Fetching location..."; // Reset location field
        setState(() {
          _selectedCourse = null; // Reset dropdown field
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Form submitted successfully!")),
        );
      } catch (e) {
        print("Error saving data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit the form. Try again later.")),
        );
      }
    }
  }

  @override
  void dispose() {
    _batchController.dispose();
    _classController.dispose();
    _enrollmentNoController.dispose();
    _nameController.dispose();
    _responseIdController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Form with Location"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Batch", _batchController),
              _buildTextField("Class", _classController),
              _buildCourseDropdown(), // Dropdown for courses
              _buildTextField("Enrollment No.", _enrollmentNoController,
                  inputType: TextInputType.number),
              _buildTextField("Name", _nameController),
              _buildTextField("Response ID", _responseIdController,
                  inputType: TextInputType.number),
              _buildReadOnlyTextField("Location Coordinates", _locationController),
              _buildReadOnlyField("Time", _time),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedCourse,
        items: _courses.map((course) {
          return DropdownMenuItem<String>(
            value: course,
            child: Text(course),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: "Course",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _selectedCourse = value!;
          });
        },
        validator: (value) =>
            value == null ? "Please select a course" : null,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label cannot be empty";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildReadOnlyTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        readOnly: true,
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
