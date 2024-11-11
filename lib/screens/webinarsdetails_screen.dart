import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/webinar.dart';

class WebinarDetailsScreen extends StatefulWidget {
  final Webinar webinar;

  const WebinarDetailsScreen({super.key, required this.webinar});

  @override
  _WebinarDetailsScreenState createState() => _WebinarDetailsScreenState();
}

class _WebinarDetailsScreenState extends State<WebinarDetailsScreen> {
  final String dummyUserId = "60c72b2f9af1f5c015a1e1c2";
  bool isRegistered = false;
  bool isLoading = true;
  bool isFull = false;

  Future<void> checkRegistrationStatus() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/registrations/${widget.webinar.id}?userId=$dummyUserId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          isRegistered = data['isRegistered'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch registration status.')),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred!')),
      );
    }
  }

  Future<void> checkWebinarFullStatus() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/webinars/${widget.webinar.id}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Webinar Data: $data");


        int currentParticipants = data['currentParticipants'] ?? 0;
        int maxParticipants = widget.webinar.maxParticipants;

        print("Current Participants: $currentParticipants, Max Participants: $maxParticipants");

        setState(() {
          isFull = currentParticipants >= maxParticipants;
        });
      } else {
        print("Error: ${response.statusCode}");
        print("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to check webinar capacity.')),
        );
      }
    } catch (error) {
      print("Error checking webinar capacity: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while checking capacity.')),
      );
    }
  }

  Future<void> registerForWebinar(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/registrations/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': dummyUserId,
          'webinarId': widget.webinar.id,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          isRegistered = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed!')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkRegistrationStatus();
    checkWebinarFullStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.webinar.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.webinar.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text('Date: ${widget.webinar.date}'),
            Text('Duration: ${widget.webinar.duration} min'),
            Text('Max Participants: ${widget.webinar.maxParticipants}'),
            const SizedBox(height: 16),
            const Text(
              'Meet Link:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : isRegistered
                ? SelectableText(
              widget.webinar.meetLink,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            )
                : isFull
                ? const Text(
              'This webinar is full.',
              style: TextStyle(color: Colors.red),
            )
                : ElevatedButton(
              onPressed: () => registerForWebinar(context),
              child: const Text('Register for Webinar'),
            ),
          ],
        ),
      ),
    );
  }
}
