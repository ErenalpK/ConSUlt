import 'package:flutter/material.dart';
import '../utils/styles.dart';
import '../widgets/faculty_card.dart';
import '../widgets/bottom_nav_bar.dart';
import 'program_codes_screen.dart';
import 'search_courses_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> faculties = const ['FENS', 'FMAN', 'FASS'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Home",
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchCoursesScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text("Search Courses"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            // Faculty Cards
            ...faculties.map((facultyName) {
              return FacultyCard(
                facultyName: facultyName,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgramCodesScreen(
                        facultyName: facultyName,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),


      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
