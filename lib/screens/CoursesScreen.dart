import 'package:flutter/material.dart';
import '../widgets/Bottom_navigation.dart'; // Ensure this path is correct
import '../widgets/custom_appBar.dart';
import 'CourseDetailsScreen.dart'; // Ensure this path is correct

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  // Sample list of courses
  final List<String> courses = [
    "Introduction to Flutter",
    "Advanced Dart Programming",
    "UI/UX Design Basics",
    "Backend Development with Node.js",
    "Machine Learning Fundamentals",
  ];
  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')), // Add an app bar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          padding: const EdgeInsets.all(5.0),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 0.5,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(courseName: courses[index]),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient overlay for the fading effect
                    Container(
                      decoration: BoxDecoration(
                        color: colors[index].withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.5,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        courses[index], // Display course name
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}