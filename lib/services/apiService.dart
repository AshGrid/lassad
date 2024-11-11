import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../models/subject.dart';
// Import the Subject model

class ApiService {
  final String baseUrl = 'http://127.0.0.1:3000/api';

//  192.168.1.12
//10.0.2.2
  // Method to fetch the list of subjects
  Future<List<Subject>> fetchSubjects() async {
    try {
      print(" loading subjects1: ");
      final response = await http.get(Uri.parse('$baseUrl/subjects'));

      // Check the response status code
      if (response.statusCode == 200) {
        print("success to load subjects1: ${response.statusCode}");
        // Parse the JSON response
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((subjectJson) => Subject.fromJson(subjectJson)).toList();
      } else {
        print("failed to load subjects1: ${response.statusCode}");
        throw Exception('Failed to load subjects: ${response.statusCode}');
      }
    } catch (error) {
      print("failed to load subjects2: $error");
      throw Exception('Failed to fetch subjects: $error');
    }
  }

  Future<void> createChapter(String name, File? pdfFile, String subjectId) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/chapters'));

    // Add chapter data
    request.fields['name'] = name;
    request.fields['subject'] = subjectId; // Assuming this is the ID of the subject

    // Add PDF file
    if (pdfFile != null) {
      String? mimeType = lookupMimeType(pdfFile.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'pdfFile', // The key expected by your API for the PDF file
          pdfFile.path,
          contentType: MediaType.parse(mimeType ?? 'application/pdf'),
        ),
      );
    }

    // Send the request
    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to create chapter: ${await response.stream.bytesToString()}');
    }
  }


  Future<void> createSubject(String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/subjects'),
        headers: {
          'Content-Type': 'application/json', // Specify JSON content
        },
        body: jsonEncode({
          'name': name,
        }),
      );

      if (response.statusCode == 201) {
        print("Subject created successfully.");
      } else {
        print("Failed to create subject: ${response.body}");
        throw Exception('Failed to create subject: ${response.body}');
      }
    } catch (e) {
      print("Error creating subject: $e");
      throw Exception('An error occurred while creating the subject: $e');
    }
  }


  Future<void> deleteChapter(String chapterId) async {
    final url = Uri.parse('$baseUrl/chapters/$chapterId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Chapter deleted successfully");
    } else if (response.statusCode == 404) {
      print("Chapter not found");
    } else {
      throw Exception('Failed to delete chapter: ${response.body}');
    }
  }

  Future<void> deleteSubject(String subjectId) async {
    final url = Uri.parse('$baseUrl/subjects/$subjectId');
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      print("subject deleted successfully");
    } else if (response.statusCode == 404) {
      print("subject not found");
    } else {
      throw Exception('Failed to delete subject: ${response.body}');
    }
  }

}
