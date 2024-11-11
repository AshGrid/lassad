import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../services/apiService.dart';


// Adjust this import based on your file structure

class AddSubjectDialog extends StatefulWidget {
 // Pass the subject ID to associate the chapter with the subject
  // Your service for creating chapters



  @override
  _AddSubjectDialogState createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  final _nameController = TextEditingController();

  final ApiService apiService = ApiService();



  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Call the createChapter method from the service
      await apiService.createSubject(
        _nameController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subject added successfully')),
      );
      Navigator.of(context).pop(); // Close the dialog
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add subject: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Subject"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Subject Name"),
            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close dialog
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _submitForm, // Submit form
          child: const Text("Add Subject"),
        ),
      ],
    );
  }
}
