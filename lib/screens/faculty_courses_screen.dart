import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'course_comments_screen.dart';


class FacultyCoursesScreen extends StatelessWidget {
  const FacultyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final String facultyName = ModalRoute.of(context)!.settings.arguments as String? ?? "FENS";

    
    final Map<String, List<String>> fensCourses = {
      "CS": [
        "CS 201","CS 204","CS 300","CS 301","CS 302","CS 303","CS 305","CS 306",
        "CS 307","CS 308","CS 310","CS 401"
      ],
      "EE": [
        "EE 200","EE 202","EE 301","EE 302","EE 303","EE 306"
      ],
      "IE": ["IE 302","IE 303","IE 304","IE 305"],
      "MAT": ["MAT 204","MAT 206","MAT 302"],
      "NS": ["NS 200","NS 201"],
      "PHYS": ["PHYS 113","PHYS 211"]
    };

    
    final coursesMap = facultyName == 'FENS' ? fensCourses : <String, List<String>>{};

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('$facultyName Classes', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Select a department to see courses",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),

            if (coursesMap.isEmpty)
              const Center(child: Text("No courses found for this faculty.")),

            ...coursesMap.entries.map((department) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      department.key,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    children: department.value.map((courseCode) {
                      return ListTile(
                        title: Text(courseCode, style: AppTextStyles.body),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CourseCommentsScreen(
        courseId: courseCode.replaceAll(" ", "").toLowerCase(),
      ),
    ),
  );
},

                      );
                    }).toList(),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}