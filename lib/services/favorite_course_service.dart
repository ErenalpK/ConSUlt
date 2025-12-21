/*import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// Favoriye ekle (SADECE ID)
  Future<void> addToFavorites(String courseId) async {
    await _favoriteRef.doc(courseId).set({
      'courseId': courseId,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Favoriden çıkar
  Future<void> removeFromFavorites(String courseId) async {
    await _favoriteRef.doc(courseId).delete();
  }

  /// Favorileri stream olarak getir
  Stream<QuerySnapshot> favoritesStream() {
    return _favoriteRef.snapshots();
  }
  
  
  //test etmek için debug metodu
  Future<void> debugFavorites() async {
  final snapshot = await _favoriteRef.get();
  print("DEBUG FAVORITE COUNT: ${snapshot.docs.length}");
  for (var doc in snapshot.docs) {
    print("DOC ID: ${doc.id}, DATA: ${doc.data()}");
  }
}

}*/


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

  /// ❤️ Favoriye ekle
  Future<void> addToFavorites(String courseId) async {
    await _favoriteRef.doc(courseId).set({
      'courseId': courseId,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// ❌ Favoriden çıkar
  Future<void> removeFromFavorites(String courseId) async {
    await _favoriteRef.doc(courseId).delete();
  }

  /// ⭐ Favorileri stream olarak getir (MEVCUT – DEĞİŞMEDİ)
  Stream<QuerySnapshot> favoritesStream() {
    return _favoriteRef.snapshots();
  }

  /// ❤️ KURS FAVORİDE Mİ?  (YENİ – SADECE BU EKLENDİ)
  Stream<bool> isFavorite(String courseId) {
    return _favoriteRef
        .doc(courseId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  /// 🧪 Debug metodu (MEVCUT – DEĞİŞMEDİ)
  Future<void> debugFavorites() async {
    final snapshot = await _favoriteRef.get();
    print("DEBUG FAVORITE COUNT: ${snapshot.docs.length}");
    for (var doc in snapshot.docs) {
      print("DOC ID: ${doc.id}, DATA: ${doc.data()}");
    }
  }
}

