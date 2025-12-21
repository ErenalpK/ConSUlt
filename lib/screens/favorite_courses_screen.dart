
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/styles.dart';
import '../services/favorite_course_service.dart';
import 'course_comments_screen.dart';

class FavoriteCoursesScreen extends StatefulWidget {
  const FavoriteCoursesScreen({super.key});

  @override
  State<FavoriteCoursesScreen> createState() =>
      _FavoriteCoursesScreenState();
}

class _FavoriteCoursesScreenState extends State<FavoriteCoursesScreen> {
  final FavoriteCourseService _favoriteService = FavoriteCourseService();

  String? selectedCourseId;
  Map<String, dynamic>? selectedCourseData;

  String selectedFaculty = "All";
  final List<String> faculties = ["All", "FENS", "FASS", "FMAN"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 2) Navigator.pushReplacementNamed(context, '/my_comments');
          if (index == 3) Navigator.pushReplacementNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'Comment'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu),
                  Text(
                    "ConSUlt",
                    style: AppTextStyles.title
                        .copyWith(color: AppColors.primary),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// FILTER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButton<String>(
                  value: selectedFaculty,
                  underline: const SizedBox(),
                  isExpanded: false,
                  items: faculties.map((faculty) {
                    return DropdownMenuItem(
                      value: faculty,
                      child: Text(faculty, style: AppTextStyles.body),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFaculty = value!;
                      selectedCourseData = null;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// FAVORITES → TEK QUERY İLE COURSES
              SizedBox(
                height: 130,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _favoriteService.favoritesStream(),
                  builder: (context, favSnap) {
                    if (!favSnap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final favDocs = favSnap.data!.docs;
                    if (favDocs.isEmpty) {
                      return const Center(child: Text("No favorite courses"));
                    }

                    final courseIds =
                        favDocs.map((e) => e['courseId'] as String).toList();

                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('courses')
                          .where(FieldPath.documentId, whereIn: courseIds)
                          .get(),
                      builder: (context, courseSnap) {
                        if (!courseSnap.hasData) {
                          return const SizedBox();
                        }

                        final courses = courseSnap.data!.docs
                            .map((e) => e.data() as Map<String, dynamic>)
                            .where((course) =>
                                selectedFaculty == "All" ||
                                course['faculty'] == selectedFaculty)
                            .toList();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];

                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCourseId = course['courseId'];
                                    selectedCourseData = course;
                                  });
                                },
                                child: Container(
                                  width: 250,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ), 
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(course['faculty'],
                                          style: AppTextStyles.caption),
                                      const SizedBox(height: 6),
                                      Text(course['courseId'],
                                          style: AppTextStyles.cardTitle),
                                      const SizedBox(height: 6),
                                      Text(course['courseName'],
                                          style: AppTextStyles.body),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              if (selectedCourseData != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildDetailCard(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(selectedCourseData!['courseId'],
              style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          Text(selectedCourseData!['description'],
              style: AppTextStyles.body),
          const SizedBox(height: 12),
          _info("Instructor", selectedCourseData!['instructor']),
          _info("Email", selectedCourseData!['instructor_mail']),
          _info("ECTS", selectedCourseData!['ects'].toString()),
          _info(
            "Prerequisites",
            selectedCourseData!['prerequisites'] != null
                ? (selectedCourseData!['prerequisites'] as List).join(", ")
                : "-",
          ),
          _info(
            "Corequisites",
            selectedCourseData!['corequisites'] != null
                ? (selectedCourseData!['corequisites'] as List).join(", ")
                : "-",
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseCommentsScreen(
          courseId: selectedCourseData!['courseId'],
        ),
      ),
    );
  },
  child: const Text("See Comments"),
),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await _favoriteService.removeFromFavorites(
                    selectedCourseData!['courseId'],
                  );
                  setState(() {
                    selectedCourseData = null;
                  });
                },
                child: const Text("Remove"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
