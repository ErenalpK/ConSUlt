import 'package:flutter/material.dart';
import '../utils/styles.dart';
import '../widgets/bottom_nav_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),

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
        child: SingleChildScrollView(
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

                  /// -------- Email --------
                  _buildLabel("Email"),
                  _buildTextField(
                    controller: _email,
                    hint: "Enter your email",
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Email required";
                      if (!v.contains("@")) return "Invalid email";
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// -------- Phone Number --------
                  _buildLabel("Phone Number"),
                  _buildTextField(
                    controller: _phone,
                    hint: "+90 (555) 555 5555",
                    validator: (v) => v == null || v.isEmpty ? "Phone number required" : null,
                  ),

                  const SizedBox(height: 20),

                  /// -------- SAVE BUTTON --------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Success"),
                              content: const Text("Profile updated successfully."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
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
