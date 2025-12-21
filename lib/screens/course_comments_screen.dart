import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/review_provider.dart';
import '../models/review.dart';
import '../utils/styles.dart';
import 'add_review_screen.dart';
import '../services/favorite_course_service.dart';

class CourseCommentsScreen extends StatefulWidget {
  final String courseId;

  const CourseCommentsScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseCommentsScreen> createState() => _CourseCommentsScreenState();
}

class _CourseCommentsScreenState extends State<CourseCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    final scaffoldContext = context;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Student Comments",
          style: AppTextStyles.sectionTitle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          /// 🔥 REAL-TIME COMMENTS
          Expanded(
            child: StreamBuilder<List<Review>>(
              stream: context
                  .read<ReviewProvider>()
                  .reviewsStream(widget.courseId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No comments yet",
                      style: AppTextStyles.body,
                    ),
                  );
                }

                final reviews = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];

                    final isMine = currentUser != null &&
                        currentUser.uid == review.createdBy;

                    return _buildCommentCard(
                      scaffoldContext,
                      review,
                      isMine,
                    );
                  },
                );
              },
            ),
          ),

          /// ➕ ADD COMMENT BUTTON
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddReviewScreen(courseId: widget.courseId),
                    ),
                  );
                },
                child: const Text(
                  "Add Comment",
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🧱 COMMENT CARD
  Widget _buildCommentCard(
    BuildContext scaffoldContext,
    Review review,
    bool isMine,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
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
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// 👤 USERNAME (COMMENT İÇİNDEN)
                Text(
                  review.createdByName,
                  style: AppTextStyles.cardTitle,
                ),

                Row(
                  children: [
                    /// ❤️ FAVORITE BUTTON
                    StreamBuilder<bool>(
                      stream: FavoriteCourseService()
                          .isFavorite(review.courseId),
                      builder: (context, snapshot) {
                        final isFavorite = snapshot.data ?? false;

                        return IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColors.primary,
                          ),
                          onPressed: () async {
                            final service = FavoriteCourseService();

                            if (isFavorite) {
                              await service
                                  .removeFromFavorites(review.courseId);
                            } else {
                              await service
                                  .addToFavorites(review.courseId);
                            }
                          },
                        );
                      },
                    ),

                    Text(
                      _formatDate(review.createdAt),
                      style: AppTextStyles.caption,
                    ),

                    if (isMine)
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          _showEditDialog(scaffoldContext, review);
                        },
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// COMMENT TEXT
            Text(
              review.comment,
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }

  /// ✏️ EDIT DIALOG
  void _showEditDialog(BuildContext context, Review review) {
    final controller = TextEditingController(text: review.comment);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Comment"),
        content: TextField(
          controller: controller,
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await context
                  .read<ReviewProvider>()
                  .updateReview(
                    review.id,
                    controller.text.trim(),
                  );
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  String _formatDate(timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
}
