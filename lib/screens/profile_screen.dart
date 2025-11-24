import 'package:consult/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../utils/styles.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Ayar satırlarını oluşturan yardımcı widget (Senin attığın koddaki yapı)
  Widget _buildSettingTile({
    required String title,
    IconData? icon,
    String? trailingText,
    required VoidCallback onTap,
    Color color = AppColors.textPrimary, // Varsayılan yazı rengi
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface, // Beyaz arka plan
          foregroundColor: color.withOpacity(0.1), // Tıklama efekti
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Köşeli (Liste görünümü için)
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: color),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.normal,
                    fontFamily: AppTextStyles.fontFamily // Senin fontun
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontFamily: AppTextStyles.fontFamily),
              ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sayfa içi geçişleri göstermek için geçici fonksiyon
    void navigate(String title) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title sayfasına gidiliyor...')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface, // Beyaz arka plan
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false, // Geri butonu yok
        title: const Text('Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            // --- KULLANICI BİLGİLERİ BÖLÜMÜ ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Yuvarlak Profil İkonu
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 10),

                  // İsim
                  const Text(
                    'Assensio',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: AppTextStyles.fontFamily),
                  ),
                  // Email
                  Text(
                    'marco_asensio@email.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontFamily: AppTextStyles.fontFamily),
                  ),
                  const SizedBox(height: 15),

                  // "Edit Profile" Butonu (Senin kodundaki tasarımın aynısı)
                  ElevatedButton(
                    onPressed: () {
                      // Named Route ile Edit Profile sayfasına git
                      Navigator.pushNamed(context, '/edit_profile');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.primary, // Mor yazı
                      elevation: 0,
                      side: const BorderSide(color: AppColors.primary), // Mor çerçeve
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: AppTextStyles.fontFamily),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),

            // --- Account Bölümü ---
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                'Account',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary, // Mor Başlık
                    fontFamily: AppTextStyles.fontFamily
                ),
              ),
            ),
            _buildSettingTile(
              title: 'Personal Information',
              icon: Icons.person_outline,
              onTap: () {}
            ),
            _buildSettingTile(
              title: 'Password & Security',
              icon: Icons.lock_outline,
              onTap: () {}
            ),

            const Divider(height: 1, thickness: 1),

            // --- Preferences Bölümü ---
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                'Preferences',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: AppTextStyles.fontFamily
                ),
              ),
            ),
            _buildSettingTile(
              title: 'Language',
              trailingText: 'English',
              onTap: () {}
            ),

            const Divider(height: 1, thickness: 1),

            // --- Privacy & Support Bölümü ---
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                'Privacy & Support',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: AppTextStyles.fontFamily
                ),
              ),
            ),
            _buildSettingTile(
              title: 'Privacy Policy',
              onTap: () {}
            ),

            const Divider(height: 1, thickness: 1),

            // --- Log Out ---
            _buildSettingTile(
              title: 'Log Out',
              icon: Icons.logout,
              color: AppColors.error, // Kırmızı renk (styles.dart'tan)
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Profile sekmesi seçili
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true, // Senin görselinde label yoktu, kapattım
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index==1) Navigator.pushReplacementNamed(context, '/favorites');
          if (index==2) Navigator.pushReplacementNamed(context, '/my_comments');
          if (index==3) {}
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