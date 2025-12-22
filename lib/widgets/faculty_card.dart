import 'package:flutter/material.dart';
import '../utils/styles.dart'; 

class FacultyCard extends StatelessWidget {
  final String facultyName;
  final VoidCallback onPressed;

  const FacultyCard({
    super.key,
    required this.facultyName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.white,
          foregroundColor: AppColors.primary, 
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 4.0, left: 4.0),
              child: Text(
                facultyName,
                style: AppTextStyles.cardTitle, 
              ),
            ),

            
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: facultyName == 'FENS'
                    ? Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWfqz_QhvZU3x9tAnKRL13MUT2I-uZoMFnPA&s',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(color: Colors.grey),
                )
                    : Image.asset(
                  
                  'assets/images/${facultyName.toLowerCase()}.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(color: Colors.grey.shade300, child: const Icon(Icons.image_not_supported)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
