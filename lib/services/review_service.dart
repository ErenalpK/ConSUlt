import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Review>> getReviewsForCourse(String courseId) {
    return _db
        .collection('comments')
        .where('courseId', isEqualTo: courseId)
        .where('createdAt', isNotEqualTo: null)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();
    });
  }

  Stream<List<Review>> getMyReviews(String userId) {
    return _db
        .collection('comments')
        .where('createdBy', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();
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
}
