
import 'package:flutter/material.dart';
import '../models/course_data.dart';
import '../utils/styles.dart';

class CourseCommentsScreen extends StatelessWidget {
  const CourseCommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Comment> comments = [
      Comment(
          studentName: "Student A",
          date: "Nov 2, 2025",

          text: "This course gave me great insight into mobile app development."
      ),
      Comment(
          studentName: "Student B",
          date: "Oct 28, 2025",
          text: "Great course content, but the workload was quite heavy."
      ),
      Comment(
          studentName: "Student C",
          date: "Oct 25, 2025",
          text: "The projects were challenging but rewarding."
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Student Comments", style: AppTextStyles.sectionTitle),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return _buildCommentCard(comments[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border))
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/add_review');
                },
                child: const Text("Add Comment", style: AppTextStyles.buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.border)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(comment.studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppTextStyles.fontFamily)),
                Text(comment.date, style: AppTextStyles.caption),
              ],
            ),

            const SizedBox(height: 12),
            Text(comment.text, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}