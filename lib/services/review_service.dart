import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Review>> getReviewsForCourse(String courseId) {
    return _db
        .collection('comments')
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .map((snapshot) {
      final reviews = snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();
      // Sort by createdAt descending
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reviews;
    });
  }

  Stream<List<Review>> getMyReviews(String userId) {
    return _db
        .collection('comments')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final reviews = snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();
      // Sort by createdAt descending
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reviews;
    });
  }

  Future<void> addReview(Review review) async {
    await _db.collection('comments').add(review.toMap());
  }


  Future<void> updateReview(String reviewId, String newComment) async {
    await _db.collection('comments').doc(reviewId).update({
      'comment': newComment,
      'lastEditedAt': Timestamp.now(),
    });
  }


  Future<void> deleteReview(String reviewId) async {
    await _db.collection('comments').doc(reviewId).delete();
  }

  /// Updates the username in all reviews created by a specific user
  Future<void> updateUsernameInAllReviews(String userId, String newUsername) async {
    final reviewsQuery = await _db
        .collection('comments')
        .where('createdBy', isEqualTo: userId)
        .get();

    final batch = _db.batch();
    for (var doc in reviewsQuery.docs) {
      batch.update(doc.reference, {'createdByName': newUsername});
    }

    if (reviewsQuery.docs.isNotEmpty) {
      await batch.commit();
    }
  }
}
