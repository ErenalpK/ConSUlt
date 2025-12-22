import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';
import '../services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewService _service = ReviewService();

  Stream<List<Review>> getReviewsForCourse(String courseId) {
    return _service.getReviewsForCourse(courseId);
  }

  Stream<List<Review>> getMyReviews(String userId) {
    return _service.getMyReviews(userId);
  }

  Future<void> addReview({
    required String courseId,
    required String comment,
    required String createdBy,
    required String createdByName,
  }) async {
    final review = Review(
      id: '',
      comment: comment,
      courseId: courseId,
      createdBy: createdBy,
      createdByName: createdByName,
      createdAt: Timestamp.now(),
    );

    await _service.addReview(review);
  }

  Future<void> updateReview(String reviewId, String newComment) async {
    await _service.updateReview(reviewId, newComment);
  }

  Future<void> deleteReview(String reviewId) async {
    await _service.deleteReview(reviewId);
  }
}
