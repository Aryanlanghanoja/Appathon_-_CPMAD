import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'admin_profile.dart';
import 'admin_report_screen.dart';
import 'admin_schedule_screen.dart';
import 'attendance_timer.dart';

class AdminHomeScreen extends StatefulWidget {
  final String facultyNo;

  const AdminHomeScreen({super.key, required this.facultyNo});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize screens with the passed facultyNo
    _screens = [
      HomeTab(facultyNo: widget.facultyNo),
      const AdminReportScreen(),
      SchedulePage(facultyNumber: widget.facultyNo),
      const AdminProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF9F9FF),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final String facultyNo;

  const HomeTab({super.key, required this.facultyNo});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now();
  final Map<String, bool> _attendanceStates = {};

  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  void markAttendanceTaken(String classId) {
    setState(() {
      _attendanceStates[classId] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildAdminHeader(),
          const SizedBox(height: 20),
          _buildDatePicker(),
          const SizedBox(height: 20),
          const Text(
            "Today's Classes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildClassList(),
        ],
      ),
    );
  }

  Widget _buildAdminHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello Admin!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome Back, Faculty: ${widget.facultyNo}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(7, (index) {
          DateTime currentDate = DateTime.now().add(Duration(days: index));
          return GestureDetector(
            onTap: () => setState(() {
              selectedDate = currentDate;
            }),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: 60,
              decoration: BoxDecoration(
                color: selectedDate.day == currentDate.day &&
                        selectedDate.month == currentDate.month
                    ? Colors.teal
                    : const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(
                    currentDate.day.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: selectedDate.day == currentDate.day &&
                              selectedDate.month == currentDate.month
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                        [currentDate.weekday % 7],
                    style: TextStyle(
                      color: selectedDate.day == currentDate.day &&
                              selectedDate.month == currentDate.month
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildClassList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('class')
            .where('date', isEqualTo: formatDate(selectedDate))
            .where('faculty_no', isEqualTo: widget.facultyNo)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No classes found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var classData = snapshot.data!.docs[index];
              String classId = classData.id;
              String subjectName =
                  classData.get('subject_name') ?? 'Unknown Subject';
              String facultyName = classData.get('faculty_name') ?? 'N/A';
              bool isAttendanceTaken =
                  classData.get('attendence_taken') ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black26),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      subjectName.isNotEmpty ? subjectName[0] : 'U',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(subjectName),
                  subtitle: Text('Faculty: $facultyName'),
                  trailing: isAttendanceTaken
                      ? const Text(
                          'Show Report',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.teal),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceTimerScreen(
                                  className: subjectName,
                                  facultyName: facultyName,
                                  onTimerComplete: () =>
                                      markAttendanceTaken(classId),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
