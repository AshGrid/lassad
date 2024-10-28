import 'package:flutter/material.dart';
import '../classes/chapter.dart';
import '../classes/subject.dart';
import '../widgets/Bottom_navigation.dart'; // Ensure this path is correct
import '../widgets/custom_appBar.dart';
import 'CoursPdfViewScreen.dart'; // Ensure this path is correct

class CourseDetailScreen extends StatefulWidget {
  final Subject course;

  CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  List<Chapter?> chapters = []; // List to hold chapters
  bool isLoading = true; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    // Initialize chapters only if course has chapters
    if (widget.course.chapters != null && widget.course.chapters!.isNotEmpty) {
      chapters = widget.course.chapters;
      isLoading = false; // Set loading state to false as chapters are loaded
    } else {
      isLoading = false; // No chapters, so stop loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name ?? "Unknown"), // Set app bar title
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : chapters.isEmpty // Check if chapters list is empty
            ? Center(child: Text('No chapters published.')) // Display message if no chapters
            : ListView.builder(
          itemCount: chapters.length, // Use the initialized chapters list
          itemBuilder: (context, index) {
            final chapter = chapters[index]; // Access chapter object

            return Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                border: Border.all(color: Colors.blue),
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
                  chapter!.name!.toUpperCase(), // Use chapter name from the object
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20, // Adjust font size as needed
                    fontWeight: FontWeight.bold,
                    fontFamily: "oswald",
                  ),
                ),
                onTap: () {
                  _showPdfChoiceDialog(context, chapter); // Pass chapter object
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
          title: Text('Select PDF for ${chapter.name}'), // Optional title
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: 1, // Only one PDF per chapter
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Open PDF'), // Display fixed option
                  onTap: () {
                    Navigator.pop(context); // Close the dialog after selection
                    _openPdf(context, chapter.pdfFile!); // Use chapter's pdfFile
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


