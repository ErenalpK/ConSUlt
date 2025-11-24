import 'package:flutter/material.dart';
import '../utils/styles.dart';
import '../models/course_data.dart';

class MyCommentsScreen extends StatefulWidget {
  const MyCommentsScreen({super.key});

  @override
  State<MyCommentsScreen> createState() => _MyCommentsScreenState();
}

class _MyCommentsScreenState extends State<MyCommentsScreen> {
  
  List<CourseDetail> myComments = [
    CourseDetail(
      faculty: "FENS",
      code: "CS310",
      name: "Mobile Application Development",
      commentCount: 10,
      description: "Challenging but rewarding course.",
      instructor: "Saima Gul",
      ects: 5.0,
      prerequisites: "CS204",
      corequisites: "None",
      comments: [],
    ),
    CourseDetail(
      faculty: "FENS",
      code: "CS404",
      name: "Artificial Intelligence",
      commentCount: 12,
      description: "Very engaging lectures and helpful materials.",
      instructor: "John Doe",
      ects: 6.0,
      prerequisites: "CS204",
      corequisites: "None",
      comments: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Center(
                child: Text(
                  "ConSUlt",
                  style: AppTextStyles.title.copyWith(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              
              Expanded(
                child: ListView.builder(
                  itemCount: myComments.length,
                  itemBuilder: (context, index) {
                    final course = myComments[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        color: AppColors.surface,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.border, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Text(
                                course.faculty,
                                style: AppTextStyles.caption.copyWith(fontSize: 12),
                              ),
                              const SizedBox(height: 4),

                              
                              Text(
                                course.code,
                                style: AppTextStyles.cardTitle,
                              ),

                              
                              Text(
                                course.name,
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 10),

                              
                              Text(
                                course.description,
                                style: AppTextStyles.body,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 12),

                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  
                                  Text(
                                    "Nov 3, 2025",
                                    style: AppTextStyles.caption,
                                  ),

                                  Row(
                                    children: [
                                      
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 20,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            myComments.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 22,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      /// ---------- BOTTOM NAVIGATION ----------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // My Comments seçili

        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,

        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/favorites');
          }
          if (index == 2) {
            /// Already on My Comments
          }
          if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'Comment'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
