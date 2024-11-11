import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Ensure this path is correct
import '../models/chapter.dart';
import '../models/subject.dart';
import '../services/apiService.dart';
import '../widgets/custom_appBar.dart';
import 'CoursPdfViewScreen.dart'; // Ensure this path is correct
import '../widgets/AddChapterDialog.dart'; // Ensure this path is correct

class CourseDetailScreen extends StatefulWidget {
  final Subject course;

  CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  List<Chapter?> chapters = []; // List to hold chapters
  bool isLoading = true; // Variable to track loading state
  bool isStudent = false;
  final apiService = ApiService();
  Future<bool> isUserStudent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      final userData = jsonDecode(userJson);
      String? userRole = userData['role']; // Assuming 'role' exists in user data
      return userRole == 'Student';
    }

    // Return false by default if the user data or role is not found
    return false;
  }
  @override
  void initState() {
    super.initState();
    if (widget.course.chapters != null && widget.course.chapters!.isNotEmpty) {
      chapters = widget.course.chapters;
      isLoading = false;
    } else {
      isLoading = false;
    }
    _checkUserRole();
  }
  Future<void> _checkUserRole() async {
    isStudent = await isUserStudent();
    setState(() {}); // Update the UI based on the role
  }
  Future<void> _confirmDeleteChapter(Chapter chapter) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this chapter?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await apiService.deleteChapter(chapter.id!);
        setState(() {
          chapters.remove(chapter); // Remove chapter locally
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chapter deleted successfully')),
        );
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!isStudent) // Conditionally show the add button
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddChapterDialog(subjectId: widget.course.id!);
                  },
                );
                // Refresh chapters list after adding a chapter
              },
              icon: const Icon(Icons.add_box_outlined),
            ),
        ],
        title: Text(widget.course.name ?? "Unknown"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : chapters.isEmpty
            ? Center(child: Text('No chapters published.'))
            : ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                trailing: !isStudent
                    ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      _confirmDeleteChapter(chapter!),
                )
                    : null, // Show delete button only if not student,}
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 8.0),
                leading: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.book,
                    color: Colors.red,
                    size: 30,

                ),
                ),
                title: Text(
                  chapter!.name!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
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

  void _showPdfChoiceDialog(BuildContext context, Chapter chapter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select PDF for ${chapter.name}'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Open PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    _openPdf(context, chapter.pdfFile!);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
