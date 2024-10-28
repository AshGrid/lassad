import 'dart:convert';
import 'package:http/http.dart' as http;

import '../classes/subject.dart';
// Import the Subject model

class ApiService {
  final String baseUrl = 'http://192.168.1.12:9090/api';

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
}
