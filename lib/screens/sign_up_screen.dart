import 'package:flutter/material.dart';
import '../utils/styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _showPassword1 = false;
  bool _showPassword2 = false;
  bool _isPressed = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "User name cannot be empty";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email cannot be empty";
    }
    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
      return "Invalid email format";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != _passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void _handleSubmit() {
    setState(() => _submitted = true);

    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: const Text("You've successfully registered!"),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: true,
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
                /// ---------- USERNAME ----------
                _buildLabel("User Name"),
                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration("Name Surname"),
                  validator: _validateName,
                ),

                const SizedBox(height: 20),

                /// ---------- EMAIL ----------
                _buildLabel("Your Email"),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                  _buildInputDecoration("SUname@sabanciuniv.edu"),
                  validator: _validateEmail,
                ),

                const SizedBox(height: 20),

                /// ---------- PASSWORD ----------
                _buildLabel("Create a Password"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword1,
                  decoration: _buildInputDecoration("********").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword1
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _showPassword1 = !_showPassword1),
                    ),
                  ),
                  validator: _validatePassword,
                ),

                const SizedBox(height: 20),

                /// ---------- CONFIRM PASSWORD ----------
                _buildLabel("Confirm Password"),
                TextFormField(
                  controller: _confirmController,
                  obscureText: !_showPassword2,
                  decoration: _buildInputDecoration("********").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword2
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _showPassword2 = !_showPassword2),
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),

                const SizedBox(height: 35),

                /// ---------- REGISTER BUTTON ----------
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 120),
                  tween: Tween<double>(
                      begin: 1.0, end: _isPressed ? 0.95 : 1.0),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() => _isPressed = true);
                            await Future.delayed(
                                const Duration(milliseconds: 150));
                            setState(() => _isPressed = false);

                            _handleSubmit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Register",
                              style: AppTextStyles.buttonText),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- LABEL ----------
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(text, style: AppTextStyles.body),
    );
  }

  // ---------- INPUT FIELD DECORATION ----------
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
