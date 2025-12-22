import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(); // PRIVATE
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _showPassword1 = false;
  bool _showPassword2 = false;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) return "Full name cannot be empty";
    if (value.trim().length < 3) return "Full name is too short";
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return "Username cannot be empty";
    if (value.contains(' ')) return "Username cannot contain spaces";
    if (value.trim().length < 3) return "Username is too short";
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Email cannot be empty";
    if (!value.endsWith("@sabanciuniv.edu")) {
      return "Only Sabancı University emails are allowed";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password cannot be empty";
    if (value.length < 8) return "Password must be at least 8 characters";
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return "Please confirm your password";
    if (value != _passwordController.text) return "Passwords do not match";
    return null;
  }

  Future<void> _handleSubmit() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1) AUTH
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user == null) throw Exception("User creation failed");

      // 2) Auth displayName = Full Name (profile'da gözüksün)
      await user.updateDisplayName(_fullNameController.text.trim());

      // 3) Firestore users doc
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': _fullNameController.text.trim(),
        'userName': _usernameController.text.trim(), // private username
        'userEmail': user.email,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'profilePhoto': null,
      }, SetOptions(merge: true));

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Account created successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";
      if (e.code == 'email-already-in-use') message = "This email is already registered";
      if (e.code == 'weak-password') message = "Password is too weak";
      if (e.code == 'invalid-email') message = "Invalid email address";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text("Sign Up", style: AppTextStyles.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            autovalidateMode:
            _submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Full Name"),
                TextFormField(
                  controller: _fullNameController,
                  decoration: _buildInputDecoration("Name Surname"),
                  validator: _validateFullName,
                ),
                const SizedBox(height: 20),

                _buildLabel("Username (Private)"),
                TextFormField(
                  controller: _usernameController,
                  decoration: _buildInputDecoration("username123"),
                  validator: _validateUsername,
                ),
                const SizedBox(height: 20),

                _buildLabel("Your Email"),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration("name@sabanciuniv.edu"),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),

                _buildLabel("Create a Password"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword1,
                  decoration: _buildInputDecoration("********").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword1 ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _showPassword1 = !_showPassword1),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),

                _buildLabel("Confirm Password"),
                TextFormField(
                  controller: _confirmController,
                  obscureText: !_showPassword2,
                  decoration: _buildInputDecoration("********").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword2 ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _showPassword2 = !_showPassword2),
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Register", style: AppTextStyles.buttonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(text, style: AppTextStyles.body),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
