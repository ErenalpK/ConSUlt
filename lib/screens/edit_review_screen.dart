import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';

class EditReviewScreen extends StatefulWidget {
  final String reviewId;
  final String currentComment;

  const EditReviewScreen({
    super.key,
    required this.reviewId,
    required this.currentComment,
  });

  @override
  State<EditReviewScreen> createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentComment);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<ReviewProvider>().updateReview(
        widget.reviewId,
        _controller.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating comment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Comment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Your comment",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

