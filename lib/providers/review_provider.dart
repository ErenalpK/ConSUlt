import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewService _service = ReviewService();

  /// 🔹 All comments for a course
  Stream<List<Review>> reviewsStream(String courseId) {
    return _service.getReviewsForCourse(courseId);
  }

  /// 🔹 ONLY current user's comments
  Stream<List<Review>> getMyReviews(String userId) {
    return _service.getMyReviews(userId);
  }

  /// 🔹 CREATE
  Future<void> addReview(Review review) async {
    await _service.addReview(review);
  }

  /// 🔹 UPDATE
  Future<void> updateReview(String reviewId, String newComment) async {
    await _service.updateReview(reviewId, newComment);
  }

  /// 🔹 DELETE
  Future<void> deleteReview(String reviewId) async {
    await _service.deleteReview(reviewId);
  }
}
