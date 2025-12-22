import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../utils/styles.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/bottom_nav_provider.dart';
import '../services/favorite_course_service.dart';
import '../models/course.dart';
import 'course_detail_screen.dart';

class FavoriteCoursesScreen extends StatefulWidget {
  const FavoriteCoursesScreen({super.key});

  @override
  State<FavoriteCoursesScreen> createState() => _FavoriteCoursesScreenState();
}

class _FavoriteCoursesScreenState extends State<FavoriteCoursesScreen> {
  @override
  void initState() {
    super.initState();
    // Ekran açıldığında index'i ayarla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bottomNav = Provider.of<BottomNavProvider>(context, listen: false);
      bottomNav.changeIndex(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final favoriteService = FavoriteCourseService();

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Favorite Courses",
            style: AppTextStyles.appBarTitle,
          ),
          backgroundColor: AppColors.surface,
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Text("Please login to see your favorite courses"),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Favorite Courses",
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoriteService.favoritesStream(),
        builder: (context, favoritesSnapshot) {
          if (favoritesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoritesSnapshot.hasError) {
            return Center(
              child: Text('Error: ${favoritesSnapshot.error}'),
            );
          }

          if (!favoritesSnapshot.hasData || favoritesSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("You haven't added any favorite courses yet."),
            );
          }

          // Get all favorite course IDs
          final favoriteCourseIds = favoritesSnapshot.data!.docs
              .map((doc) => doc.id)
              .toList();

          if (favoriteCourseIds.isEmpty) {
            return const Center(
              child: Text("You haven't added any favorite courses yet."),
            );
          }

          // Fetch course details for each favorite
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('courses')
                .where(FieldPath.documentId, whereIn: favoriteCourseIds)
                .snapshots(),
            builder: (context, coursesSnapshot) {
              if (coursesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (coursesSnapshot.hasError) {
                return Center(
                  child: Text('Error loading courses: ${coursesSnapshot.error}'),
                );
              }

              if (!coursesSnapshot.hasData || coursesSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No courses found for your favorites."),
                );
              }

              // Sadece büyük harfli document ID'lere sahip dersleri al
              final courses = coursesSnapshot.data!.docs
                  .where((doc) => doc.id == doc.id.toUpperCase())
                  .map((doc) => Course.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
                  .toList();

              // Sort by code
              courses.sort((a, b) => a.code.compareTo(b.code));

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          course.code.toUpperCase(),
                          style: AppTextStyles.cardTitle,
                        ),
                        subtitle: Text(
                          course.name,
                          style: AppTextStyles.body,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailScreen(course: course),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
