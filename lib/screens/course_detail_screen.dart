import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/course.dart';
import '../utils/styles.dart';
import '../services/favorite_course_service.dart';
import 'course_comments_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final FavoriteCourseService _favoriteService = FavoriteCourseService();
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    try {
      final doc = await _favoriteService.favoriteRef
          .doc(widget.course.code)
          .get();
      if (mounted) {
        setState(() {
          _isFavorite = doc.exists;
        });
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (FirebaseAuth.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to add favorites')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFavorite) {
        await _favoriteService.removeFromFavorites(widget.course.code);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Removed from favorites')),
          );
        }
      } else {
        await _favoriteService.addToFavorites(widget.course.code);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to favorites')),
          );
        }
      }
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.course.code, style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.course.name, style: AppTextStyles.title),
            const SizedBox(height: 10),
            Text("Instructor: ${widget.course.instructor}",
                style: AppTextStyles.body),
            const SizedBox(height: 10),
            Text("ECTS: ${widget.course.ects}", style: AppTextStyles.body),
            const SizedBox(height: 16),
            // Prerequisites
            if (widget.course.prerequisites.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Prerequisites: ", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      widget.course.prerequisites.map((e) => e.toString()).join(", "),
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            // Corequisites
            if (widget.course.corequisites.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Corequisites: ", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      widget.course.corequisites.map((e) => e.toString()).join(", "),
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Text(widget.course.description, style: AppTextStyles.body),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseCommentsScreen(
                            courseId: widget.course.code,
                          ),
                        ),
                      );
                    },
                    child: const Text("See Comments"),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _isLoading ? null : _toggleFavorite,
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : AppColors.primary,
                    size: 28,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
