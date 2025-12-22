import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/styles.dart';
import '../models/course.dart';
import 'course_detail_screen.dart';

class SearchCoursesScreen extends StatefulWidget {
  const SearchCoursesScreen({super.key});

  @override
  State<SearchCoursesScreen> createState() => _SearchCoursesScreenState();
}

class _SearchCoursesScreenState extends State<SearchCoursesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Course> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  Future<void> _searchCourses(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    try {
      final queryUpper = query.trim().toUpperCase();
      
      // Get all courses and filter client-side (case-insensitive)
      final snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .get();

      final results = <Course>[];
      for (var doc in snapshot.docs) {
        try {
          final course = Course.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
          
          // Search in courseId and courseName (case-insensitive)
          if (course.courseId.toUpperCase().contains(queryUpper) ||
              course.courseName.toUpperCase().contains(queryUpper.toUpperCase())) {
            results.add(course);
          }
        } catch (e) {
          print('Error parsing course: $e');
        }
      }

      // Sort by courseId
      results.sort((a, b) => a.courseId.compareTo(b.courseId));

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching courses: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Search Courses",
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by course code or name (e.g., CS310)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                            _hasSearched = false;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
              onChanged: (value) {
                setState(() {});
                _searchCourses(value);
              },
              textCapitalization: TextCapitalization.none,
            ),
          ),

          // Results
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _hasSearched
                    ? _searchResults.isEmpty
                        ? const Center(
                            child: Text('No courses found.'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final course = _searchResults[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Card(
                                  color: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      course.courseId.toUpperCase(),
                                      style: AppTextStyles.cardTitle,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course.courseName,
                                          style: AppTextStyles.body,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${course.faculty} - ${course.department}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CourseDetailScreen(course: course),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                    : const Center(
                        child: Text(
                          'Enter a course code or name to search',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

