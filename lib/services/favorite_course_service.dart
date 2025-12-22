
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteCourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  CollectionReference get _favoriteRef =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('favoriteCourses');
  
  // Public getter for checking favorite status
  CollectionReference get favoriteRef => _favoriteRef;


  Future<void> addToFavorites(String courseId) async {
    await _favoriteRef.doc(courseId).set({
      'courseId': courseId,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }


  Future<void> removeFromFavorites(String courseId) async {
    await _favoriteRef.doc(courseId).delete();
  }


  Stream<QuerySnapshot> favoritesStream() {
    return _favoriteRef.snapshots();
  }


  Stream<bool> isFavorite(String courseId) {
    return _favoriteRef
        .doc(courseId)
        .snapshots()
        .map((doc) => doc.exists);
  }


  
}

