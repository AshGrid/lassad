import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Ensure you have this import for PDFView

class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  PDFViewerScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Use Expanded to take full available height
            Expanded(
              child: PDFView(
                filePath: filePath,
                enableSwipe: true,         // Enables swipe gestures to change pages
                swipeHorizontal: true,     // Allows horizontal swiping
                autoSpacing: false,        // Disable auto spacing
                pageFling: true,          // Enables page fling
                fitPolicy: FitPolicy.BOTH, // Fit policy for content
              ),
            ),
          ],
        ),
      ),
    );
  }
}
