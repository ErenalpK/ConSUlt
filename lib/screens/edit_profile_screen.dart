import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/styles.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/review_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  String _oldUsername = '';
  final ReviewService _reviewService = ReviewService();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _location = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _username.dispose();
    _fullname.dispose();
    _email.dispose();
    _phone.dispose();
    _bio.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final username = (data['userName'] ?? '').toString();
        setState(() {
          _oldUsername = username;
          _username.text = username;
          _fullname.text = (data['fullName'] ?? user.displayName ?? '').toString();
          _email.text = (data['userEmail'] ?? user.email ?? '').toString();
        });
      } else {
  
        setState(() {
          _oldUsername = '';
          _username.text = '';
          _fullname.text = user.displayName ?? '';
          _email.text = user.email ?? '';
        });
      }
    } catch (e) {
      
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        _oldUsername = '';
        _username.text = '';
        _fullname.text = user?.displayName ?? '';
        _email.text = user?.email ?? '';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newUsername = _username.text.trim();
      final usernameChanged = newUsername != _oldUsername;

   
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': _fullname.text.trim(),
        'userName': newUsername,
        'userEmail': _email.text.trim(),
      }, SetOptions(merge: true));

     
      await user.updateDisplayName(_fullname.text.trim());

     
      if (usernameChanged) {
        await _reviewService.updateUsernameInAllReviews(user.uid, newUsername);
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Profile updated successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pop(context); 
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,


      bottomNavigationBar: const CustomBottomNavBar(),

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Edit Profile", style: AppTextStyles.appBarTitle.copyWith(color: Colors.black)),
        centerTitle: true,
      ),

      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  /// -------- Username --------
                  _buildLabel("Username"),
                  _buildTextField(
                    controller: _username,
                    hint: "Enter your username",
                    validator: (v) => v == null || v.isEmpty ? "Username required" : null,
                  ),

                  const SizedBox(height: 20),

                  /// -------- Full Name --------
                  _buildLabel("Full Name"),
                  _buildTextField(
                    controller: _fullname,
                    hint: "Enter your full name",
                    validator: (v) => v == null || v.isEmpty ? "Full name required" : null,
                  ),

                  const SizedBox(height: 20),

                  /// -------- SAVE BUTTON --------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _saveProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Save Changes",
                        style: AppTextStyles.buttonText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLabel(String label) {
    return Text(label, style: AppTextStyles.sectionTitle.copyWith(fontSize: 14));
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
    );
  }
}
