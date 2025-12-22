import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// Providers
import 'providers/review_provider.dart';
import 'providers/bottom_nav_provider.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/favorite_courses_screen.dart';
import 'screens/my_comments_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/faculty_courses_screen.dart';
import 'auth/auth_gate.dart';
import 'screens/favorite_courses_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ],
      child: const ConsultApp(),
    ),
  );
}

class ConsultApp extends StatelessWidget {
  const ConsultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/auth': (context) => const AuthGate(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),


        '/favorites': (context) => FavoriteCoursesScreen(),
        '/my_comments': (context) => MyCommentsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
      },
    );
  }
}
