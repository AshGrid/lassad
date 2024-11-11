import 'package:http/http.dart' as http;
import 'dart:convert';

class ResumeService {
  final String baseUrl = 'http://127.0.0.1:3000'; // Define baseUrl here inside the class

  // Add Resume
  Future<bool> addResume(Map<String, dynamic> resumeData, String? pdfFilePath) async {
    final url = Uri.parse('$baseUrl/api/resume'); // Use baseUrl inside the method

    print('Preparing to send resume data: $resumeData'); // Debugging line

    try {
      // Prepare the request body
      Map<String, dynamic> requestBody = {
        "title": resumeData['title'],
        "reference": resumeData['reference'],
        "level": resumeData['level'],
        "price": resumeData['price'],
        "owner": resumeData['owner'],
        "description": resumeData['description'],
        "filePath": pdfFilePath, // Add filePath if needed
      };

      print('Sending POST request to $url'); // Debugging line

      // Send the POST request with an extended timeout
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(Duration(seconds: 50)); // Increased timeout

      // Log the response status and body
      print('Response status: ${response.statusCode}'); // Log the status
      print('Response body: ${response.body}'); // Log the body

      // Check if the response status code indicates success
      return response.statusCode == 201; // Successful creation
    } catch (error) {
      print('Error adding resume: $error'); // Log the error
      return false; // Return false in case of an error
    }
  }

  // Fetch unpaid courses
  Future<List<Map<String, dynamic>>> getUnpaidCourses() async {
    final url = Uri.parse('$baseUrl/api/resume/unpaid'); // Use baseUrl

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse and return the list of unpaid courses
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Failed to load unpaid courses: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching unpaid courses: $error');
      return [];
    }
  }

  // Mark course as paid
  Future<void> markCourseAsPaid(String courseId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/resume/$courseId/markPaid'),
        body: jsonEncode({'courseId': courseId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successfully marked as paid, refresh the courses
        fetchPaidCourses();
      } else {
        throw Exception('Failed to mark course as paid');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fetch paid courses
  Future<List<Map<String, dynamic>>> fetchPaidCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/resume/paid'));

      if (response.statusCode == 200) {
        final List courses = jsonDecode(response.body);
        return courses.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load paid courses');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Add a comment to a resume
  Future<void> addComment(String resumeId, String username, String comment) async {
    final url = '$baseUrl/api/resume/$resumeId/comment'; // Correct URL format

    print('Adding comment to resume ID: $resumeId');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': username,
        'comment': comment,
      }),
    );

    print('Request body: ${jsonEncode({'user': username, 'comment': comment})}'); // Log the request body

    if (response.statusCode == 200) {
      print('Comment added successfully');
    } else {
      print('Failed to add comment: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to add comment');
    }
  }

  // Get all comments for a resume
  Future<List<Map<String, dynamic>>> getAllComments(String resumeId) async {
    final url = Uri.parse('$baseUrl/api/resume/$resumeId/comments');

    try {
      final response = await http.get(url);
      print('Response body: ${response.body}'); // Debugging line

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Failed to load comments: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching comments: $error');
      return [];
    }
  }

  // Add a rating to a resume
  Future<void> addRating(String resumeId, double rating) async {
    final url = Uri.parse('$baseUrl/api/resume/$resumeId/rate'); // Adjust the endpoint if necessary

    // Ensure rating is within the allowed range (1-5)
    if (rating < 1 || rating > 5) {
      throw Exception('Rating must be between 1 and 5.');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'rating': rating,
      }),
    );

    if (response.statusCode == 200) {
      print('Rating added successfully!');
    } else if (response.statusCode == 400) {
      print('Invalid rating value. Must be between 1 and 5.');
      throw Exception('Invalid rating value.');
    } else if (response.statusCode == 404) {
      print('Resume not found.');
      throw Exception('Resume not found.');
    } else {
      print('Failed to add rating. Status code: ${response.statusCode}');
      throw Exception('Failed to add rating.');
    }
  }

  // Fetch all ratings (stars) for a resume
  Future<List<int>> getResumeStars(String resumeId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/resume/getResumeStars/$resumeId'));

    if (response.statusCode == 200) {
      return List<int>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load ratings for resume');
    }
  }
}
