import 'package:flutter/material.dart';
import '../models/course_data.dart';
import '../utils/styles.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  static final CourseDetail courseData = CourseDetail(
    faculty: "FENS",
    code: "CS310",
    name: "Mobile Application Development",
    commentCount: 18,
    description:
    "Mobile Application Development explores the essentials of this course in to mobile world. Students will learn to build mobile applications from scratch using modern frameworks and development tools, focusing on both Android and iOS platforms.",
    instructor: "Not assigned",
    ects: 5.0,
    prerequisites: "CS201",
    corequisites: "CS301-6",
    comments: [],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("ConSUlt", style: AppTextStyles.appBarTitle),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),

      /// 🚫 — BOTTOM NAVIGATION BAR TAMAMEN KALDIRILDI —
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(context, courseData),
            const SizedBox(height: 16),
            _buildDescriptionCard(courseData),
            const SizedBox(height: 16),
            _buildDetailsCard(courseData),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.comment, color: AppColors.primary),
                label: const Text(
                  "View All Student Comments",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/course_comments');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, CourseDetail data) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.faculty, style: AppTextStyles.caption),
            const SizedBox(height: 4),
            Text(data.code, style: AppTextStyles.cardTitle),
            const SizedBox(height: 4),
            Text(
              data.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
            const SizedBox(height: 12),

            InkWell(
              onTap: () => Navigator.pushNamed(context, '/course_comments'),
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    "${data.commentCount} comments",
                    style: const TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(CourseDetail data) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Course Description",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(data.description, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(CourseDetail data) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _detailItem("Instructor", data.instructor),
            _detailItem("ECTS", "${data.ects}"),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
      ],
    );
  }
}
