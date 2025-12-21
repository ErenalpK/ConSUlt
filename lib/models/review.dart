import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String courseId;
  final String comment;
  final String createdBy;
  final String createdByName; // 👈 YENİ
  final Timestamp createdAt;

  Review({
    required this.id,
    required this.courseId,
    required this.comment,
    required this.createdBy,
    required this.createdByName, // 👈 YENİ
    required this.createdAt,
  });

  /// 🔹 Firestore → Dart
  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Review(
      id: doc.id,
      courseId: data['courseId'],
      comment: data['comment'],
      createdBy: data['createdBy'],
      createdByName: data['createdByName'] ?? "Unknown", // 👈 fallback
      createdAt: data['createdAt'],
    );
  }

  /// 🔹 Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'comment': comment,
      'createdBy': createdBy,
      'createdByName': createdByName, // 👈 YENİ
      'createdAt': createdAt,
    };
  }
}
