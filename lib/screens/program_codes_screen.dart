import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/styles.dart';
import 'course_codes_screen.dart';

class ProgramCodesScreen extends StatelessWidget {
  final String facultyName;

  const ProgramCodesScreen({
    super.key,
    required this.facultyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '$facultyName Programs',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('courses')
            .where('faculty', isEqualTo: facultyName)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final error = snapshot.error.toString();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Firestore Permission Error',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.contains('permission-denied')
                          ? 'Please check Firestore security rules.\nThe courses collection may need read permissions.'
                          : 'Error: $error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Retry
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProgramCodesScreen(facultyName: facultyName),
                          ),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No programs found for this faculty."),
                  const SizedBox(height: 8),
                  Text(
                    "Faculty: $facultyName",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Get unique departments (program codes) - sadece büyük harfli document ID'lere sahip dersleri al
          final Set<String> programCodes = {};
          for (var doc in snapshot.data!.docs) {
            // Sadece büyük harfli document ID'lere sahip dersleri al
            if (doc.id == doc.id.toUpperCase()) {
              final dept = doc['department'] as String?;
              if (dept != null && dept.isNotEmpty) {
                programCodes.add(dept);
              }
            }
          }

          if (programCodes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No programs found for this faculty."),
                  const SizedBox(height: 8),
                  Text(
                    "Faculty: $facultyName",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final sortedProgramCodes = programCodes.toList()..sort();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: sortedProgramCodes.map((programCode) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseCodesScreen(
                          facultyName: facultyName,
                          programCode: programCode,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        programCode,
                        style: AppTextStyles.cardTitle,
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
