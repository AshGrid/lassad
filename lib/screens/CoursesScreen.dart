import 'package:flutter/material.dart';
import 'package:moodle_app/services/apiService.dart';
import '../classes/subject.dart';
import '../widgets/Bottom_navigation.dart'; // Ensure this path is correct
import '../widgets/custom_appBar.dart';
import 'CourseDetailsScreen.dart'; // Ensure this path is correct

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Subject> courses = [];
  final ApiService apiService = ApiService();
  List<Color> colors = [];
  bool isLoading = true; // Variable to track loading state

  Future<void> fetchSubjects() async {
    try {
      List<Subject> fetchedCourses =
          await apiService.fetchSubjects(); // Replace with your API call
      setState(() {
        courses = fetchedCourses; // Update the state with the fetched courses
        colors = generateColors(
            courses.length); // Generate colors based on the number of courses
        isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      // Handle any errors that may occur during the fetch
      print("Error fetching subjects: $e");
      setState(() {
        isLoading = false; // Set loading to false even if there is an error
      });
    }
  }

  List<Color> generateColors(int count) {
    List<Color> generatedColors = [];
    for (int i = 0; i < count; i++) {
      generatedColors.add(Colors.primaries[i % Colors.primaries.length]
          .withOpacity(0.5)); // Use colors from the primaries list
    }
    return generatedColors;
  }

  @override
  void initState() {
    super.initState();
    fetchSubjects(); // Call the fetch function when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')), // Add an app bar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading // Check loading state
            ? Center(
                child: CircularProgressIndicator(), // Display loading indicator
              )
            : GridView.builder(
                padding: const EdgeInsets.all(5.0),
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio:
                      0.8, // Adjusted aspect ratio for a wider appearance
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailScreen(course: courses[index]),
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
                          // Gradient overlay for the fading effect
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.1, // Reduced height for cards
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
                                height: MediaQuery.of(context).size.height *
                                    0.1, // Reduced height for cards
                                decoration: BoxDecoration(
                                  color: colors[index].withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Text(
                                    courses[index].name ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.0),
                              Center(
                                child: Text(
                                  "Chapters: ${courses[index].chapters.length.toString()}",
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
}
