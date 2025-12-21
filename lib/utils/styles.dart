import 'package:flutter/material.dart';

class AppColors {
  
  static const Color primary = Color(0xFF4A148C); 
  static const Color secondary = Color(0xFF03DAC6);

 
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white; 
  static final Color border = Colors.grey.shade200;

 
  static const Color textPrimary = Colors.black87;
  static const Color error = Color(0xFFB00020);
  static const Color star = Colors.amber; 
}

class AppTextStyles {
  
  static const String fontFamily = 'AppFont';



  
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

 
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: Colors.grey,
  );



  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.textPrimary,
    height: 1.4,
  );
}
