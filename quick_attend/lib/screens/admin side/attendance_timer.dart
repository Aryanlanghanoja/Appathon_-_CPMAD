import 'dart:async';
import 'package:flutter/material.dart';

class AttendanceTimerScreen extends StatefulWidget {
  final String className;
  final String facultyName;
  final VoidCallback onTimerComplete;

  const AttendanceTimerScreen({
    super.key,
    required this.className,
    required this.facultyName,
    required this.onTimerComplete,
  });

  @override
  _AttendanceTimerScreenState createState() => _AttendanceTimerScreenState();
}

class _AttendanceTimerScreenState extends State<AttendanceTimerScreen> {
  late Timer _timer;
  int _remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        widget.onTimerComplete(); // Notify parent
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Timer'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Class: ${widget.className}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Faculty: ${widget.facultyName}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Time Remaining: $_remainingSeconds seconds',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
