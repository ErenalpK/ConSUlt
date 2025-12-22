import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/favorite_courses_screen.dart';
import '../screens/my_comments_screen.dart';
import '../screens/profile_screen.dart';
import '../providers/bottom_nav_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }


        if (!snapshot.hasData) {
          return const LoginScreen();
        }

       
        return Consumer<BottomNavProvider>(
          builder: (context, bottomNav, _) {
            
            if (bottomNav.isLoading) {
              return const HomeScreen();
            }

         
            switch (bottomNav.currentIndex) {
              case 0:
                return const HomeScreen();
              case 1:
                return const FavoriteCoursesScreen();
              case 2:
                return const MyCommentsScreen();
              case 3:
                return const ProfileScreen();
              default:
                return const HomeScreen();
            }
          },
        );
      },
    );
  }
}
