import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/styles.dart';
import 'course_comments_screen.dart';

class FacultyCoursesScreen extends StatelessWidget {
  final String facultyName;

  const FacultyCoursesScreen({
    super.key,
    required this.facultyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          '$facultyName Courses',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .where('faculty', isEqualTo: facultyName)
            .orderBy('department')
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No courses found."),
            );
          }

          /// 🔹 Department → Courses Map
          final Map<String, List<QueryDocumentSnapshot>> grouped = {};

          for (var doc in snapshot.data!.docs) {
            final dept = doc['department'];
            grouped.putIfAbsent(dept, () => []).add(doc);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: grouped.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  children: entry.value.map((courseDoc) {
                    return ListTile(
                      title: Text(courseDoc['courseId'].toUpperCase()),
                      subtitle: Text(courseDoc['courseName']),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseCommentsScreen(
                              courseId: courseDoc['courseId'],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
