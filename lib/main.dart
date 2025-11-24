import 'package:consult/screens/my_comments_screen.dart';
import 'package:flutter/material.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/faculty_courses_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/course_comments_screen.dart';
import 'screens/add_review_screen.dart';
import 'screens/favorite_courses_screen.dart';
import 'screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';
import 'screens/sign_up_screen.dart';


void main() {
  runApp(const ConsultApp());
}

class ConsultApp extends StatelessWidget {
  const ConsultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',

      routes: {
        
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),

       
        '/home': (context) => const HomeScreen(),
        '/favorites': (context) => const FavoriteCoursesScreen(),
        '/profile': (context) => const ProfileScreen(),

        
        '/faculty_courses': (context) => const FacultyCoursesScreen(),
        '/course_detail': (context) => const CourseDetailScreen(),

       
        '/course_comments': (context) => const CourseCommentsScreen(),
        '/add_review': (context) => const AddReviewScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),

      
        '/my_comments': (context) => const MyCommentsScreen()
      },
    );
  }
}
