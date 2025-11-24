import 'package:flutter/material.dart';
import 'utils/styles.dart'; // Renk ve Font ayarları için

// Ekranlarımızı içeri alıyoruz (Import)
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
      debugShowCheckedModeBanner: false, // Sağ üstteki 'Debug' yazısını kaldırır

      // --- GENEL TEMA AYARLARI ---
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        // Tüm uygulamada 'AppFont' (Roboto) geçerli olsun:
        fontFamily: AppTextStyles.fontFamily,

        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),

        // AppBar varsayılan stili
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

        // Buton varsayılan stili
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

      // --- NAVİGASYON ROTALARI (Named Routes) ---
      // Uygulama ilk açıldığında hangi rota (sayfa) gelsin?
      initialRoute: '/',

      routes: {
        // Ana Sayfa: Ders Detayı
        '/': (context) => const CourseDetailScreen(),

        // Yorumlar Sayfası
        '/course_comments': (context) => const CourseCommentsScreen(),

        // Yorum Ekleme Formu
        '/add_review': (context) => const AddReviewScreen(),
      },
    );
  }
}