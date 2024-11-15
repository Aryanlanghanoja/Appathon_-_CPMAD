import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
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
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello World! I am',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '.........',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Student',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Date Picker Row with Boxed Days and More Width
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(7, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 60, // Set fixed width for more space
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9), // Background color for each day
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8), // Adjusted padding
                      child: Column(
                        children: [
                          Text(
                            '${17 + index}', // Sample dates
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index % 7],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Today's Classes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Class List with Rounded Capsules
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9), // Set background color to D9D9D9
                      borderRadius: BorderRadius.circular(30), // High borderRadius for capsule shape
                      border: Border.all(color: Colors.black26),
                    ),
                    child: const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          'G',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text('Mathematics'),
                      subtitle: Text('you are marked present'),
                      trailing: Text(
                        '9:30am',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
