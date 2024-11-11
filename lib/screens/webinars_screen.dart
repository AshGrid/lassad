import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_app/screens/addwebinars_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/webinar.dart';
import 'webinarsdetails_screen.dart';

class RoundTablesWebinarsScreen extends StatefulWidget {
  const RoundTablesWebinarsScreen({super.key});

  @override
  State<RoundTablesWebinarsScreen> createState() => _RoundTablesWebinarsScreenState();
}


class _RoundTablesWebinarsScreenState extends State<RoundTablesWebinarsScreen> {
  List<Webinar> webinars = [];
  bool isLoading = true;
  String userName = 'Username';
  String userRole = 'Role';

  @override
  void initState() {
    super.initState();
    _fetchWebinars();
  }
  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load user data from the 'user' JSON string
      String? userJson = prefs.getString('user');
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        userName = userData['username'] ?? 'Username';
        userRole = userData['role'] ?? 'Role'; // Assuming 'role' is part of user data
      }
      // Load profile image path and create a File object if it exists
      // Set loading to false once data is loaded
      isLoading = false;
    });
  }

  Future<void> _fetchWebinars() async {
    final url = Uri.parse('http://10.0.2.2:3000/webinars');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> webinarData = json.decode(response.body);
        setState(() {
          webinars = webinarData.map((json) => Webinar.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load webinars');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading webinars: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Round Tables & Webinars'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: webinars.length,
        itemBuilder: (context, index) {
          final webinar = webinars[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.video_call),
              title: Text(webinar.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(webinar.description),
                  const SizedBox(height: 4.0),
                  Text('Date: ${webinar.date}'),
                  Text('Duration: ${webinar.duration} min'),
                  Text('Max Participants: ${webinar.maxParticipants}'),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebinarDetailsScreen(webinar: webinar),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton:userRole=="Instructor"? FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Webinar screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddWebinarScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Webinar',
      ):Container(),
    );
  }
}
