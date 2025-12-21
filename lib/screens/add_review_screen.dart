import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review.dart';
import '../providers/review_provider.dart';
import '../utils/styles.dart';

class AddReviewScreen extends StatefulWidget {
  final String courseId;

  const AddReviewScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      /// 🔹 1. USERNAME’I USERS KOLEKSİYONUNDAN AL
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data() as Map<String, dynamic>;
      final username = userData['userName'] as String? ?? "Unknown";

      /// 🔹 2. REVIEW OLUŞTUR (USERNAME İLE!)
      final review = Review(
        id: '',
        courseId: widget.courseId,
        comment: _reviewController.text.trim(),
        createdBy: user.uid,
        createdByName: username, // 👈 KRİTİK SATIR
        createdAt: Timestamp.now(),
      );

      /// 🔹 3. FIRESTORE’A KAYDET
      await context.read<ReviewProvider>().addReview(review);

      Navigator.pop(context); // geri dön → yorumlar anında güncellenecek
    } catch (e) {
      print("🔥 ADD COMMENT ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add comment")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Add Comment",
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.surface,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _reviewController,
                maxLines: 5,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  labelText: "Your Comment",
                  hintText: "Share your experience about this course...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a comment';
                  }
                  if (value.trim().length < 5) {
                    return 'Comment must be at least 5 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit",
                          style: AppTextStyles.buttonText,
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
