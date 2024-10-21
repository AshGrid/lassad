import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../widgets/Bottom_navigation.dart'; // Ensure this path is correct
import '../widgets/custom_appBar.dart';
import 'CourseDetailsScreen.dart'; // Ensure this path is correct


class PDFViewScreen extends StatelessWidget {
  final String pdfPath;

  const PDFViewScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pdfPath.split('/').last), // Display the PDF file name
      ),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}