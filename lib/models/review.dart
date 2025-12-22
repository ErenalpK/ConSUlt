import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String comment;
  final String courseId;
  final String createdBy;
  final String createdByName;
  final Timestamp createdAt;

  Review({
    required this.id,
    required this.comment,
    required this.courseId,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Review(
      id: doc.id,
      comment: data['comment'] ?? '',
      courseId: data['courseId'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdByName: data['createdByName'] ?? 'anonymous',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'courseId': courseId,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
