import 'package:flutter/material.dart';
import '../widgets/Bottom_navigation.dart'; // Ensure this path is correct
import '../widgets/custom_appBar.dart';
import 'CoursPdfViewScreen.dart'; // Ensure this path is correct

import 'dart:io';



class CourseDetailScreen extends StatelessWidget {
  final String courseName;

  CourseDetailScreen({Key? key, required this.courseName}) : super(key: key);

  final List<String> chapters = [
    "Introduction to Flutter",
    "Advanced Dart Programming",
    "UI/UX Design Basics",
    "Backend Development with Node.js",
    "Machine Learning Fundamentals",
  ];

  final List<String> pdfs = [
    "Introduction to Flutter",
    "Advanced Dart Programming",
    "UI/UX Design Basics",
    "Backend Development with Node.js",
    "Machine Learning Fundamentals",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName), // Set the app bar title to the course name
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chapter = chapters[index];

            return Container(
margin: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                border: Border.all(color: Colors.blue

                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                leading: Container(
                  width: 55, // Box width
                  height: 55, // Box height
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the box
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25), // Shadow color
                        blurRadius: 4.0, // Blur radius
                        spreadRadius: 0.0, // Spread radius
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                ),
                title: Text(
                  chapter.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20, // Adjust font size as needed
                    fontWeight: FontWeight.bold,
                    fontFamily: "oswald",

                  ),
                ),
                onTap: () {
                  _showPdfChoiceDialog(context, chapter);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showPdfChoiceDialog(BuildContext context, String chapter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: pdfs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(pdfs[index]),
                  onTap: () {
                    // Implement the logic for opening or downloading the PDF here
                    Navigator.pop(context); // Close the dialog after selection
                    _openPdf(context, pdfs[index]);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _openPdf(BuildContext context, String pdfPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewScreen(pdfPath: pdfPath),
      ),
    );
  }
}


// Example ChapterDetailScreen for displaying chapter details
class ChapterDetailScreen extends StatelessWidget {
  final String chapterName;

  const ChapterDetailScreen({Key? key, required this.chapterName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(chapterName)), // Set the app bar title to chapter name
      body: Center(
        child: Text(
          'Details for $chapterName',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
