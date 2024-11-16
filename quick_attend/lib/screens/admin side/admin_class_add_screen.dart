import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class ClassDetailsPage extends StatefulWidget {
  final DateTime selectedDay;

  const ClassDetailsPage({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _ClassDetailsPageState createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  // Controllers
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController batchNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController numberOfStudentsController = TextEditingController();
  final TextEditingController uniquenumberController = TextEditingController();

  // Faculty details
  String facultyName = "";
  String facultyNumber = "";

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  // Initialization
  Future<void> _initializePage() async {
    dateController.text = DateFormat('yyyy-MM-dd').format(widget.selectedDay);
    await _loadFacultyDetails();
    await _fetchCurrentLocation();
  }

  Future<void> _loadFacultyDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      facultyName = prefs.getString('facultyName') ?? "Unknown";
      facultyNumber = prefs.getString('facultyNumber') ?? "0000";
    });
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
        desiredAccuracy: LocationAccuracy.high,
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
        // Fetch the current highest `un_no`
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('class')
            .orderBy('un_no', descending: true)
            .limit(1)
            .get();

        int newUnNo = 1; // Default starting value if no documents exist
        if (querySnapshot.docs.isNotEmpty) {
          var lastDoc = querySnapshot.docs.first;
          newUnNo = (lastDoc['un_no'] as int) + 1; // Increment the highest un_no
        }

        // Add the new class details with the incremented `un_no`
        await FirebaseFirestore.instance.collection('class').add({
          'class_name': classNameController.text,
          'sub_name': subjectController.text,
          'batch_name': batchNameController.text,
          'date': dateController.text,
          'time': timeController.text,
          'location': locationController.text,
          'no_of_student': numberOfStudentsController.text,
          'faculty_name': facultyName,
          'faculty_no': facultyNumber,
          'un_no': newUnNo, // Use the incremented un_no
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Class Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(classNameController, 'Class Name'),
              const SizedBox(height: 16),
              _buildTextField(subjectController, 'Subject'),
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
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
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
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
    );
  }
}
