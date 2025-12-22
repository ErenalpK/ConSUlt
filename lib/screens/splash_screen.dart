import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'home_screen.dart';
import 'favorite_courses_screen.dart';
import 'my_comments_screen.dart';
import 'profile_screen.dart';
import '../providers/bottom_nav_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    _startNavigation();
  }

  Future<void> _startNavigation() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
      return;
    }

   
    final bottomNav = Provider.of<BottomNavProvider>(context, listen: false);

 
    int attempts = 0;
    while (bottomNav.isLoading && attempts < 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
      if (!mounted) return;
    }

    if (!mounted) return;

    Widget targetScreen;
    switch (bottomNav.currentIndex) {
      case 0:
        targetScreen = const HomeScreen();
        break;
      case 1:
        targetScreen = const FavoriteCoursesScreen();
        break;
      case 2:
        targetScreen = const MyCommentsScreen();
        break;
      case 3:
        targetScreen = const ProfileScreen();
        break;
      default:
        targetScreen = const HomeScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => targetScreen),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/app_logo.jpeg",
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

