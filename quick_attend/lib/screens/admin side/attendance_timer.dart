// // import 'dart:async';
// // import 'package:flutter/material.dart';

// // class AttendanceTimerScreen extends StatefulWidget {
// //   final String className;
// //   final String facultyName;
// //   final VoidCallback onTimerComplete;

// //   const AttendanceTimerScreen({
// //     super.key,
// //     required this.className,
// //     required this.facultyName,
// //     required this.onTimerComplete,
// //   });

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _AttendanceTimerScreenState createState() => _AttendanceTimerScreenState();
// // }

// // class _AttendanceTimerScreenState extends State<AttendanceTimerScreen> {
// //   late Timer _timer;
// //   int _remainingSeconds = 60;

// //   @override
// //   void initState() {
// //     super.initState();
// //     startTimer();
// //   }

// //   void startTimer() {
// //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (_remainingSeconds > 0) {
// //         setState(() {
// //           _remainingSeconds--;
// //         });
// //       } else {
// //         timer.cancel();
// //         widget.onTimerComplete(); // Notify parent
// //         Navigator.pop(context);
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _timer.cancel();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Attendance Timer'),
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Text(
// //               'Class: ${widget.className}',
// //               style: const TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white),
// //             ),
// //             const SizedBox(height: 10),
// //             Text(
// //               'Faculty: ${widget.facultyName}',
// //               style: const TextStyle(fontSize: 18, color: Colors.white),
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               'Time Remaining: $_remainingSeconds seconds',
// //               style: const TextStyle(fontSize: 18, color: Colors.white),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'package:flutter/material.dart';

// class AttendanceTimerScreen extends StatefulWidget {
//   final String className;
//   final String facultyName;
//   final VoidCallback onTimerComplete;

//   const AttendanceTimerScreen({
//     super.key,
//     required this.className,
//     required this.facultyName,
//     required this.onTimerComplete,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _AttendanceTimerScreenState createState() => _AttendanceTimerScreenState();
// }

// class _AttendanceTimerScreenState extends State<AttendanceTimerScreen> {
//   late Timer _timer;
//   int _remainingSeconds = 60;

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   void startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingSeconds > 0) {
//         setState(() {
//           _remainingSeconds--;
//         });
//       } else {
//         timer.cancel();
//         widget.onTimerComplete(); // Notify parent
//         Navigator.pop(context);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   String formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F9FF),
//       appBar: AppBar(
//         title: const Text(
//           'Attendance Timer',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.teal,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Card(
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Text(
//                       widget.className,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.teal,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       'Faculty: ${widget.facultyName}',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.teal,
//                 borderRadius: BorderRadius.circular(100),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.teal.withOpacity(0.3),
//                     spreadRadius: 5,
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     formatTime(_remainingSeconds),
//                     style: const TextStyle(
//                       fontSize: 48,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const Text(
//                     'Remaining Time',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 40),
//             const Text(
//               'Students can mark their attendance\nduring this time window',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
  // ignore: library_private_types_in_public_api
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

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      appBar: AppBar(
        title: const Text(
          'Attendance Timer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        // Wrapped with Center
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      widget.className,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Faculty: ${widget.facultyName}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 200, // Fixed width for circular container
              height: 200, // Fixed height for circular container
              decoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                // Center the timer content
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Remaining Time',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Students can mark their attendance\nduring this time window',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
