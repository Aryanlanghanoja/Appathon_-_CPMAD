import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class ClassDetailsPage extends StatefulWidget {
  final DateTime selectedDay;
  final String facultyNumber;

  const ClassDetailsPage({
    super.key,
    required this.selectedDay,
    required this.facultyNumber,
  });

  @override
  _ClassDetailsPageState createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController batchNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController numberOfStudentsController =
      TextEditingController();

  List<String> courseNames = [];
  String? selectedCourseName;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    // Set the selected date in the date controller
    dateController.text = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

    // Fetch and display the current location
    await _fetchCurrentLocation();

    // Fetch course names
    await _fetchCourseNames();
  }

  Future<void> _fetchCourseNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('courses').get();
      setState(() {
        courseNames = querySnapshot.docs
            .map((doc) => doc['course_name'] as String)
            .toList();
      });
    } catch (e) {
      _showSnackbar('Failed to fetch courses: $e');
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackbar('Location services are disabled. Please enable them.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackbar('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackbar('Location permissions are permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );
      setState(() {
        locationController.text = "${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      _showSnackbar('Error fetching location: $e');
    }
  }

  Future<void> _submitData() async {
    if (_validateInputs()) {
      try {
        // Fetch the highest class_id and calculate a new one
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('class')
            .orderBy('class_id', descending: true)
            .limit(1)
            .get();

        int newClassId = 1;
        if (querySnapshot.docs.isNotEmpty) {
          var lastDoc = querySnapshot.docs.first;
          newClassId = (lastDoc['class_id'] as int) + 1;
        }

        // Add the class details to Firestore
        await FirebaseFirestore.instance.collection('class').add({
          'class_name': classNameController.text,
          'subject_name': subjectController.text,
          'batch_name': batchNameController.text,
          'date': dateController.text,
          'time': timeController.text,
          'location': locationController.text,
          'no_of_student': int.parse(numberOfStudentsController.text),
          'faculty_name': "N/A", // Optional: Replace with fetched faculty name
          'faculty_no': widget.facultyNumber, // Use the passed faculty number
          'class_id': newClassId,
          'attendence_taken': false,
        });

        _showSnackbar('Class details submitted successfully!');
        Navigator.pop(context);
      } catch (e) {
        _showSnackbar('Failed to submit class details: $e');
      }
    }
  }

  bool _validateInputs() {
    if (classNameController.text.isEmpty ||
        subjectController.text.isEmpty ||
        batchNameController.text.isEmpty ||
        dateController.text.isEmpty ||
        locationController.text.isEmpty ||
        numberOfStudentsController.text.isEmpty ||
        timeController.text.isEmpty) {
      _showSnackbar('All fields are required.');
      return false;
    }
    return true;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        timeController.text = pickedTime.format(context);
      });
    }
  }

  Widget _buildSubjectDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCourseName,
      hint: const Text('Select a Subject'),
      items: courseNames.map((course) {
        return DropdownMenuItem<String>(
          value: course,
          child: Text(course),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCourseName = value;
          subjectController.text = value!; // Set the selected value
        });
      },
      decoration: InputDecoration(
        labelText: 'Subject',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Class Details'),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Faculty Number: ${widget.facultyNumber}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField(classNameController, 'Class Name'),
              const SizedBox(height: 16),
              _buildSubjectDropdown(), // Dropdown for Subject
              const SizedBox(height: 16),
              _buildTextField(batchNameController, 'Batch Name'),
              const SizedBox(height: 16),
              _buildTextField(
                dateController,
                'Date',
                readOnly: true,
                onTap: _selectDate,
                suffixIcon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),
              _buildTextField(locationController, 'Location'),
              const SizedBox(height: 16),
              _buildTextField(
                numberOfStudentsController,
                'Number of Students',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                timeController,
                'Time',
                readOnly: true,
                onTap: _selectTime,
                suffixIcon: Icons.access_time,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool readOnly = false,
    Function()? onTap,
    IconData? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon:
            suffixIcon != null ? Icon(suffixIcon, color: Colors.teal) : null,
      ),
    );
  }
}
