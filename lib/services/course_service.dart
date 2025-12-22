import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class CourseService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Course>> getCoursesByFaculty(String faculty) {
    return _db
        .collection('courses')
        .where('faculty', isEqualTo: faculty)
        .orderBy('courseId')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Course.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }
}
