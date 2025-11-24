import 'package:flutter/material.dart';
import '../models/course_data.dart';
import '../utils/styles.dart';

class FavoriteCoursesScreen extends StatelessWidget {
  const FavoriteCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CourseDetail> favorites = [
      CourseDetail(
        faculty: "FENS",
        code: "CS310",
        name: "Mobile Application Development",
        commentCount: 18,
        description:
        "Mobile Application Development The objective of this course is to provide students with the skills needed to build mobile applications.",
        instructor: "Saima Gul",
        ects: 5,
        prerequisites: "CS204",
        corequisites: "CS310 R",
        comments: [],
      ),
      CourseDetail(
        faculty: "FENS",
        code: "CS404",
        name: "Artificial Intelligence",
        commentCount: 12,
        description:
        "This course introduces the basic concepts of artificial intelligence and machine learning.",
        instructor: "John Doe",
        ects: 6,
        prerequisites: "CS300",
        corequisites: "None",
        comments: [],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) {}
          if (index == 2) Navigator.pushReplacementNamed(context, '/my_comments');
          if (index == 3) Navigator.pushReplacementNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'Comment'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Center(
                child: Text(
                  "ConSUlt",
                  style: AppTextStyles.title.copyWith(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ...favorites.map((course) =>
                  _buildFavoriteCard(context, course)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, CourseDetail c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(c.faculty, style: AppTextStyles.caption),

          
          const SizedBox(height: 3),
          Text(c.code, style: AppTextStyles.cardTitle),

          
          Text(
            c.name,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 12),

          
          Row(
            children: [
              const Icon(Icons.star_border, size: 20),
              const SizedBox(width: 4),
              const Text("4.8"),

              const SizedBox(width: 16),
              const Icon(Icons.comment, size: 20),
              const SizedBox(width: 4),
              Text("${c.commentCount} comments"),
            ],
          ),

          const SizedBox(height: 12),

          
          Text(
            "Course Description",
            style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            c.description,
            style: AppTextStyles.body,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

       
          _buildInfoRow("Instructor", c.instructor),
          _buildInfoRow("ECTS", "${c.ects}"),
          _buildInfoRow("Corequisites", c.corequisites),
          _buildInfoRow("Prerequisites", c.prerequisites),

          const SizedBox(height: 16),

          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/course_comments'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("See Comments", style: TextStyle(color: Colors.white),),
              ),

            
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Remove", style: TextStyle(color: Colors.white),),

              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(
            value,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
