import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../utils/styles.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/bottom_nav_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Ekran açıldığında index'i ayarla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bottomNav = Provider.of<BottomNavProvider>(context, listen: false);
      bottomNav.changeIndex(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            // Create user document if it doesn't exist
            FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'fullName': user.displayName ?? 'Unknown',
              'userName': 'Unknown',
              'userEmail': user.email ?? '',
              'createdBy': user.uid,
              'createdAt': FieldValue.serverTimestamp(),
              'profilePhoto': null,
            }, SetOptions(merge: true));

            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final fullName = (data['fullName'] ?? user.displayName ?? 'Unknown').toString();
          final email = (data['userEmail'] ?? user.email ?? '').toString();

          return ListView(
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
                      fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),
                    Text(email, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/edit_profile'),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.lock_outline, color: AppColors.primary),
                title: const Text(
                  'Change Password',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showChangePasswordDialog(context),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: AppColors.error,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
                onTap: () => _showDeleteAccountDialog(context),
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
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                },
              ),

              const SizedBox(height: 20),
              const Center(
                child: Text('Version 1.0.0',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    bool showCurrentPassword = false;
    bool showNewPassword = false;
    bool showConfirmPassword = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'Change Password',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Current Password
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: !showCurrentPassword,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      hintText: 'Enter your current password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showCurrentPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showCurrentPassword = !showCurrentPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Current password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // New Password
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: !showNewPassword,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter new password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showNewPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showNewPassword = !showNewPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Confirm Password
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !showConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      hintText: 'Confirm new password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                if (!formKey.currentState!.validate()) return;

                setState(() {
                  isLoading = true;
                });

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null || user.email == null) {
                    throw Exception('User not found');
                  }

                  // Re-authenticate with current password
                  final credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPasswordController.text.trim(),
                  );
                  await user.reauthenticateWithCredential(credential);

                  // Update password
                  await user.updatePassword(
                    newPasswordController.text.trim(),
                  );

                  if (context.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password changed successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  String errorMessage = 'Failed to change password';
                  if (e.code == 'wrong-password') {
                    errorMessage = 'Current password is incorrect';
                  } else if (e.code == 'weak-password') {
                    errorMessage = 'New password is too weak';
                  } else if (e.code == 'requires-recent-login') {
                    errorMessage =
                    'Please log out and log in again to change password';
                  }

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  if (context.mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    bool showPassword = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'Delete Account',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This action cannot be undone. All your data will be permanently deleted, including:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Your profile information\n• All your comments\n• All your favorite courses',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: 'Enter your password to confirm',
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                if (!formKey.currentState!.validate()) return;

                setState(() {
                  isLoading = true;
                });

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null || user.email == null) {
                    throw Exception('User not found');
                  }

                  // Re-authenticate with password
                  final credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: passwordController.text.trim(),
                  );
                  await user.reauthenticateWithCredential(credential);

                  final userId = user.uid;

                  // 1. Delete all favorite courses (subcollection)
                  final favoritesSnapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('favoriteCourses')
                      .get();

                  final batch1 = FirebaseFirestore.instance.batch();
                  for (var doc in favoritesSnapshot.docs) {
                    batch1.delete(doc.reference);
                  }
                  if (favoritesSnapshot.docs.isNotEmpty) {
                    await batch1.commit();
                  }

                  // 2. Delete all comments/reviews created by user
                  final commentsSnapshot = await FirebaseFirestore.instance
                      .collection('comments')
                      .where('createdBy', isEqualTo: userId)
                      .get();

                  final batch2 = FirebaseFirestore.instance.batch();
                  for (var doc in commentsSnapshot.docs) {
                    batch2.delete(doc.reference);
                  }
                  if (commentsSnapshot.docs.isNotEmpty) {
                    await batch2.commit();
                  }

                  // 3. Delete user document
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .delete();

                  // 4. Delete Firebase Auth account
                  await user.delete();

                  if (context.mounted) {
                    Navigator.pop(dialogContext);
                    // Navigate to login and clear all routes
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                          (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  String errorMessage = 'Failed to delete account';
                  if (e.code == 'wrong-password') {
                    errorMessage = 'Password is incorrect';
                  } else if (e.code == 'requires-recent-login') {
                    errorMessage =
                    'Please log out and log in again to delete account';
                  }

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  if (context.mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
