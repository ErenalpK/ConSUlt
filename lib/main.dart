import 'package:flutter/material.dart';
import 'utils/styles.dart'; 


import 'screens/course_detail_screen.dart';
import 'screens/course_comments_screen.dart';
import 'screens/add_review_screen.dart';

void main() {
  runApp(const ConsultApp());
}

class ConsultApp extends StatelessWidget {
  const ConsultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConSUlt',
      debugShowCheckedModeBanner: false, 

      
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        
        fontFamily: AppTextStyles.fontFamily,

        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.primary),
          titleTextStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

       
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

     
      initialRoute: '/',

      routes: {
       
        '/': (context) => const CourseDetailScreen(),

       
        '/course_comments': (context) => const CourseCommentsScreen(),

      
        '/add_review': (context) => const AddReviewScreen(),
      },
    );
  }
}
