
import 'package:flutter/material.dart';
import '../utils/styles.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();



  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {


      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Success", style: TextStyle(color: AppColors.primary)),
          content: const Text("Thank you! Your review has been submitted anonymously."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text("OK", style: TextStyle(color: AppColors.primary)),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Add Review", style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.surface,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextFormField(
                controller: _reviewController,
                maxLines: 5,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  labelText: "Your Review",
                  hintText: "Share your experience about this course...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (value.length < 10) {
                    return 'Review must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),


              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                      "Submit Review",
                      style: AppTextStyles.buttonText
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}