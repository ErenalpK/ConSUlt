import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/styles.dart';
import '../models/course.dart';
import 'course_detail_screen.dart';

class CourseCodesScreen extends StatelessWidget {
  final String facultyName;
  final String programCode;

  const CourseCodesScreen({
    super.key,
    required this.facultyName,
    required this.programCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '$programCode Courses',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('courses')
            .where('faculty', isEqualTo: facultyName)
            .where('department', isEqualTo: programCode)
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
                            builder: (_) => CourseCodesScreen(
                              facultyName: facultyName,
                              programCode: programCode,
                            ),
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
            return const Center(
              child: Text("No courses found for this program."),
            );
          }

          // Parse courses
          final courses = <Course>[];
          for (var doc in snapshot.data!.docs) {
            try {
              courses.add(Course.fromFirestore(doc.data() as Map<String, dynamic>, doc.id));
            } catch (e) {
              print('Error parsing course: $e');
            }
          }

          if (courses.isEmpty) {
            return const Center(
              child: Text("No courses found for this program."),
            );
          }

          // Sort by courseId
          courses.sort((a, b) => a.courseId.compareTo(b.courseId));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: courses.map((course) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      course.courseId.toUpperCase(),
                      style: AppTextStyles.cardTitle,
                    ),
                    subtitle: Text(
                      course.courseName,
                      style: AppTextStyles.body,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailScreen(course: course),
                        ),
                      );
                    },
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

