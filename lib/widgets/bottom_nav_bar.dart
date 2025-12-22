import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/styles.dart';
import '../providers/bottom_nav_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  void _onTap(BuildContext context, int index) {
    final bottomNav = Provider.of<BottomNavProvider>(context, listen: false);

    // Aynı tab'a tıklanırsa hiçbir şey yapma
    if (index == bottomNav.currentIndex) return;

    // Tab'ı değiştir ve SharedPreferences'a kaydet
    bottomNav.changeIndex(index);

    // İlgili ekrana yönlendir
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/favorites');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/my_comments');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, bottomNav, _) {
        return BottomNavigationBar(
          currentIndex: bottomNav.currentIndex,
          onTap: (index) => _onTap(context, index),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'Comment'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        );
      },
    );
  }
}
