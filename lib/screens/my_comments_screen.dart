import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/review_provider.dart';
import '../models/review.dart';
import '../utils/styles.dart';

class MyCommentsScreen extends StatelessWidget {
  const MyCommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "My Comments",
                  style: AppTextStyles.title.copyWith(
                    fontSize: 22,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: StreamBuilder<List<Review>>(
                  stream: context
                      .read<ReviewProvider>()
                      .getMyReviews(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "You have not written any comments yet.",
                          style: AppTextStyles.body,
                        ),
                      );
                    }

                    final reviews = snapshot.data!;

                    return ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];

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
                                  review.courseId,
                                  style: AppTextStyles.cardTitle,
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  review.comment,
                                  style: AppTextStyles.body,
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDate(review.createdAt),
                                      style: AppTextStyles.caption,
                                    ),
                                    Row(
                                      children: [
                                        /// ✏️ EDIT
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined),
                                          onPressed: () {
                                            _showEditDialog(
                                              context,
                                              review,
                                            );
                                          },
                                        ),

                                        /// 🗑 DELETE (sonra iyileştireceğiz)
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
                                    )
                                  ],
                                )
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) Navigator.pushReplacementNamed(context, '/favorites');
          if (index == 2) {}
          if (index == 3) Navigator.pushReplacementNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'Comment'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
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

  String _formatDate(timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
}
