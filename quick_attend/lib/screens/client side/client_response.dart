import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassListPage extends StatefulWidget {
  @override
  _ClassListPageState createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  // Reference to Firestore collection
  final CollectionReference _classCollection =
      FirebaseFirestore.instance.collection('class');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Class List'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _classCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No classes available.'));
            }

            // Retrieve list of documents from the snapshot
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                // Use a safe map with null checks
                var data = documents[index].data() as Map<String, dynamic>?;

                if (data == null) {
                  return const Center(
                    child: Text('Error: Invalid document data.'),
                  );
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextRow('Class Name:', data['class_name'] ?? 'N/A'),
                        _buildTextRow('Subject:', data['sub_name'] ?? 'N/A'),
                        _buildTextRow('Batch Name:', data['batch_name'] ?? 'N/A'),
                        _buildTextRow('Date:', data['date'] ?? 'N/A'),
                        _buildTextRow('Time:', data['time'] ?? 'N/A'),
                        _buildTextRow('Location:', data['location'] ?? 'N/A'),
                        _buildTextRow(
                            'No. of Students:', data['no_of_student']?.toString() ?? 'N/A'),
                        _buildTextRow('Faculty Name:', data['faculty_name'] ?? 'N/A'),
                        _buildTextRow('Faculty Number:', data['faculty_no'] ?? 'N/A'),
                        _buildTextRow('Unique Number:', data['un_no']?.toString() ?? 'N/A'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
