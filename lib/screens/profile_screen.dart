import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  Widget _listTile({
    required String title,
    IconData? icon,
    String? trailing,
    Color color = AppColors.textPrimary,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: icon != null ? Icon(icon, color: color) : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: color,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
      trailing: trailing != null
          ? Text(trailing,
              style: const TextStyle(color: Colors.grey, fontSize: 14))
          : const Icon(Icons.chevron_right, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.displayName ?? 'Assensio',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/edit_profile'),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),

          const Divider(),

          _sectionTitle('Account'),
          _listTile(
            title: 'Personal Information',
            icon: Icons.person_outline,
            onTap: () {},
          ),
          _listTile(
            title: 'Password & Security',
            icon: Icons.lock_outline,
            onTap: () {},
          ),

          const Divider(),

          _sectionTitle('Preferences'),
          _listTile(
            title: 'Language',
            icon: Icons.language,
            trailing: 'English',
            onTap: () {},
          ),

          const Divider(),

          _sectionTitle('Privacy & Support'),
          _listTile(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {},
          ),

          const Divider(),

          ListTile(
  leading: const Icon(Icons.logout, color: AppColors.error),
  title: const Text(
    'Log Out',
    style: TextStyle(
      color: AppColors.error,
      fontFamily: AppTextStyles.fontFamily,
    ),
  ),
  onTap: () async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login', 
        (route) => false,
      );
    }
  },
),


          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),

     
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/favorites');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/my_comments');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment), label: 'Comment'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
