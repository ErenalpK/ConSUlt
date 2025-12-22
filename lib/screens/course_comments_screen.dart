import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/review_provider.dart';
import '../models/review.dart';
import '../utils/styles.dart';
import 'add_review_screen.dart';


class CourseCommentsScreen extends StatefulWidget {
  final String courseId;

  const CourseCommentsScreen({super.key, required this.courseId});

  @override
  State<CourseCommentsScreen> createState() => _CourseCommentsScreenState();
}

class _CourseCommentsScreenState extends State<CourseCommentsScreen> {
  late final Stream<List<Review>> _reviewsStream;

  @override
  void initState() {
    super.initState();
    _reviewsStream = context.read<ReviewProvider>().getReviewsForCourse(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.courseId,
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.surface,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Comments",
                  style: AppTextStyles.title.copyWith(
                    fontSize: 22,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<List<Review>>(
                  stream: _reviewsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: AppTextStyles.body,
                        ),
                      );
                    }

                    final reviews = snapshot.data ?? [];

                    if (reviews.isEmpty) {
                      return const Center(
                        child: Text(
                          'No comments yet.',
                          style: AppTextStyles.body,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        final isOwner = review.createdBy == currentUser?.uid;

                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 16),
                          color: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.border),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.createdByName,
                                  style: AppTextStyles.cardTitle,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  review.comment,
                                  style: AppTextStyles.body,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDate(review.createdAt),
                                      style: AppTextStyles.caption,
                                    ),
                                    if (isOwner)
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined),
                                            onPressed: () {
                                              _showEditDialog(context, review);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<ReviewProvider>()
                                                  .deleteReview(review.id);
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Add Comment Button at the bottom
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (currentUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please login to add comments')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddReviewScreen(
                      courseId: widget.courseId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_comment),
              label: const Text("Add Comment"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Review review) {
    final controller = TextEditingController(text: review.comment);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Comment"),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Update your comment",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await context
                  .read<ReviewProvider>()
                  .updateReview(review.id, controller.text.trim());

              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
}
