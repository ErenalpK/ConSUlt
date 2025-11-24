import 'package:flutter/material.dart';

class AppColors {
  // Ana Renkler
  static const Color primary = Color(0xFF4A148C); // Sabancı Moru
  static const Color secondary = Color(0xFF03DAC6);

  // Arka Plan ve Yüzey
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white; // KART RENGİ (Eksikti)
  static final Color border = Colors.grey.shade200; // ÇERÇEVE RENGİ (Eksikti)

  // Metin ve İkonlar
  static const Color textPrimary = Colors.black87;
  static const Color error = Color(0xFFB00020);
  static const Color star = Colors.amber; // YILDIZ RENGİ (Eksikti)
}

class AppTextStyles {
  // Font Ailesi (pubspec.yaml ile aynı isimde olmalı)
  static const String fontFamily = 'AppFont';

  // --- EKSİK OLAN STİLLER ---

  // AppBar Başlığı
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Bölüm Başlıkları ("Student Comments" vb.)
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Kart İçindeki Ders Kodu (CS310 vb.)
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Buton Yazıları
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Küçük Açıklama Yazıları (Tarih vb.)
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: Colors.grey,
  );

  // --- STANDART STİLLER ---

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