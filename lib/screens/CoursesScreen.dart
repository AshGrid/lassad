import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../models/subject.dart';
import '../services/apiService.dart';
import '../widgets/AddSubjectDialog.dart';
// Ensure this path is correct
import '../widgets/custom_appBar.dart';
import 'CourseDetailsScreen.dart'; // Ensure this path is correct

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Subject> courses = [];
  List<Subject> filteredCourses = [];
  final ApiService apiService = ApiService();
  List<Color> colors = [];
  bool isLoading = true;
  String searchQuery = "";
  bool isStudent = false; // Flag to check if the user is a student

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

  Future<void> fetchSubjects() async {
    try {
      List<Subject> fetchedCourses = await apiService.fetchSubjects();
      setState(() {
        courses = fetchedCourses;
        filteredCourses = courses; // Initialize filtered list
        colors = generateColors(courses.length);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching subjects: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Color> generateColors(int count) {
    List<Color> generatedColors = [];
    for (int i = 0; i < count; i++) {
      generatedColors.add(
        Colors.primaries[i % Colors.primaries.length].withOpacity(0.5),
      );
    }
    return generatedColors;
  }

  void _filterCourses(String query) {
    setState(() {
      searchQuery = query;
      filteredCourses = courses
          .where((course) =>
          course.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSubjects();
    _checkUserRole();
  }
  Future<void> _checkUserRole() async {
    isStudent = await isUserStudent();
    setState(() {}); // Update the UI based on the role
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _filterCourses,
          decoration: InputDecoration(
            hintText: 'Search subjects...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (!isStudent) // Conditionally show the add button
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddSubjectDialog();
                  },
                );
                fetchSubjects(); // Refresh the subject list after adding
              },
              icon: const Icon(Icons.add_box_outlined),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          padding: const EdgeInsets.all(5.0),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredCourses.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CourseDetailScreen(course: filteredCourses[index]),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.5,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            color: colors[index].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Text(
                                  filteredCourses[index].name ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                if (!isStudent) // Conditionally show the delete button
                                  IconButton(
                                    onPressed: () => _confirmDeleteSubject(filteredCourses[index]),
                                    icon: const Icon(Icons.delete_forever),
                                  ),
                              ],
                            )
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Center(
                          child: Text(
                            "Chapters: ${filteredCourses[index].chapters.length.toString()}",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Future<void> _confirmDeleteSubject(Subject subject) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this subject?'),
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
        await apiService.deleteSubject(subject.id!);
        setState(() {
          courses.remove(subject); // Remove chapter locally
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subject deleted successfully')),
        );
      } catch (e) {
        print('Error: $e');
      }
    }
  }

}
