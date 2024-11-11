import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../services/apiService.dart';


 // Adjust this import based on your file structure

class AddChapterDialog extends StatefulWidget {
  final String subjectId; // Pass the subject ID to associate the chapter with the subject
   // Your service for creating chapters

  AddChapterDialog({
    required this.subjectId,

  });

  @override
  _AddChapterDialogState createState() => _AddChapterDialogState();
}

class _AddChapterDialogState extends State<AddChapterDialog> {
  final _nameController = TextEditingController();
  File? _pdfFile;
  final ApiService chapterService = ApiService();

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Only allow PDF files
    );

    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty || _pdfFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Call the createChapter method from the service
      await chapterService.createChapter(
        _nameController.text,
        _pdfFile,
        widget.subjectId, // Pass the subject ID
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chapter added successfully')),
      );
      Navigator.of(context).pop(); // Close the dialog
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add chapter: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Chapter"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Chapter Name"),
            ),
            SizedBox(height: 16),
            TextButton.icon(
              onPressed: _pickPdfFile,
              icon: Icon(Icons.attach_file),
              label: Text(_pdfFile != null ? "PDF Selected" : "Select PDF"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close dialog
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _submitForm, // Submit form
          child: Text("Add Chapter"),
        ),
      ],
    );
  }
}
