// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:flutter/services.dart';
// // ignore: depend_on_referenced_packages
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// class ClassListPage extends StatefulWidget {
//   @override
//   _ClassListPageState createState() => _ClassListPageState();
// }

// class _ClassListPageState extends State<ClassListPage> {
//   // Reference to Firestore collection
//   final CollectionReference _classCollection =
//       FirebaseFirestore.instance.collection('class');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text('Class List'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _classCollection.snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text('No classes available.'));
//                   }

//                   // Retrieve list of documents from the snapshot
//                   List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

//                   return ListView.builder(
//                     itemCount: documents.length,
//                     itemBuilder: (context, index) {
//                       // Use a safe map with null checks
//                       var data =
//                           documents[index].data() as Map<String, dynamic>?;

//                       if (data == null) {
//                         return const Center(
//                           child: Text('Error: Invalid document data.'),
//                         );
//                       }

//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildTextRow(
//                                   'Class Name:', data['class_name'] ?? 'N/A'),
//                               _buildTextRow(
//                                   'Subject:', data['sub_name'] ?? 'N/A'),
//                               _buildTextRow(
//                                   'Batch Name:', data['batch_name'] ?? 'N/A'),
//                               _buildTextRow('Date:', data['date'] ?? 'N/A'),
//                               _buildTextRow('Time:', data['time'] ?? 'N/A'),
//                               _buildTextRow(
//                                   'Location:', data['location'] ?? 'N/A'),
//                               _buildTextRow('No. of Students:',
//                                   data['no_of_student']?.toString() ?? 'N/A'),
//                               _buildTextRow('Faculty Name:',
//                                   data['faculty_name'] ?? 'N/A'),
//                               _buildTextRow('Faculty Number:',
//                                   data['faculty_no'] ?? 'N/A'),
//                               _buildTextRow('Unique Number:',
//                                   data['un_no']?.toString() ?? 'N/A'),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: _generatePdfReport,
//               child: const Text('Generate Report'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.black54),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _generatePdfReport() async {
//     final pdf = pw.Document();

//     try {
//       // Fetch data from Firestore
//       final QuerySnapshot snapshot = await _classCollection.get();
//       final List<QueryDocumentSnapshot> documents = snapshot.docs;

//       if (documents.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('No data available to generate the report.')),
//         );
//         return;
//       }

//       // Add content to the PDF
//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) {
//             return pw.Column(
//               children: [
//                 pw.Text(
//                   'Class List Report',
//                   style: pw.TextStyle(
//                     fontSize: 24,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 16),
//                 pw.Table(
//                   border: pw.TableBorder.all(),
//                   children: [
//                     pw.TableRow(
//                       children: [
//                         pw.Text('Class Name',
//                             style:
//                                 pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         pw.Text('Subject',
//                             style:
//                                 pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         pw.Text('Batch Name',
//                             style:
//                                 pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         pw.Text('Date',
//                             style:
//                                 pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         pw.Text('Time',
//                             style:
//                                 pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                       ],
//                     ),
//                     ...documents.map((doc) {
//                       final data = doc.data() as Map<String, dynamic>?;
//                       return pw.TableRow(
//                         children: [
//                           pw.Text(data?['class_name'] ?? 'N/A'),
//                           pw.Text(data?['sub_name'] ?? 'N/A'),
//                           pw.Text(data?['batch_name'] ?? 'N/A'),
//                           pw.Text(data?['date'] ?? 'N/A'),
//                           pw.Text(data?['time'] ?? 'N/A'),
//                         ],
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       );

//       // Save PDF to file
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/class_list_report.pdf');
//       await file.writeAsBytes(await pdf.save());

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Report saved at ${file.path}')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error generating report: $e')),
//       );
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:html' as html;

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
      body: Column(
        children: [
          Expanded(
            child: Padding(
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
                      var data =
                          documents[index].data() as Map<String, dynamic>?;

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
                              _buildTextRow(
                                  'Class Name:', data['class_name'] ?? 'N/A'),
                              _buildTextRow(
                                  'Subject:', data['sub_name'] ?? 'N/A'),
                              _buildTextRow(
                                  'Batch Name:', data['batch_name'] ?? 'N/A'),
                              _buildTextRow('Date:', data['date'] ?? 'N/A'),
                              _buildTextRow('Time:', data['time'] ?? 'N/A'),
                              _buildTextRow(
                                  'Location:', data['location'] ?? 'N/A'),
                              _buildTextRow('No. of Students:',
                                  data['no_of_student']?.toString() ?? 'N/A'),
                              _buildTextRow('Faculty Name:',
                                  data['faculty_name'] ?? 'N/A'),
                              _buildTextRow('Faculty Number:',
                                  data['faculty_no'] ?? 'N/A'),
                              _buildTextRow('Unique Number:',
                                  data['un_no']?.toString() ?? 'N/A'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _generatePdfReport,
              child: const Text('Generate Report'),
            ),
          ),
        ],
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

  Future<void> _generatePdfReport() async {
    final pdf = pw.Document();

    try {
      // Fetch data from Firestore
      final QuerySnapshot snapshot = await _classCollection.get();
      final List<QueryDocumentSnapshot> documents = snapshot.docs;

      if (documents.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No data available to generate the report.')),
        );
        return;
      }

      // Add content to the PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(
                  'Class List Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text('Class Name',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Subject',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Batch Name',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Date',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Time',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    ...documents.map((doc) {
                      final data = doc.data() as Map<String, dynamic>?;
                      return pw.TableRow(
                        children: [
                          pw.Text(data?['class_name'] ?? 'N/A'),
                          pw.Text(data?['sub_name'] ?? 'N/A'),
                          pw.Text(data?['batch_name'] ?? 'N/A'),
                          pw.Text(data?['date'] ?? 'N/A'),
                          pw.Text(data?['time'] ?? 'N/A'),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            );
          },
        ),
      );

      if (kIsWeb) {
        // Web-specific implementation
        final bytes = await pdf.save();
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = 'class_list_report.pdf'
          ..click();
        html.Url.revokeObjectUrl(url);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF downloaded successfully!')),
        );
      } else {
        // Mobile/Desktop-specific implementation
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/class_list_report.pdf');
        await file.writeAsBytes(await pdf.save());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report saved at ${file.path}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating report: $e')),
      );
    }
  }
}
