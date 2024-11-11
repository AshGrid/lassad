import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddWebinarScreen extends StatefulWidget {
  const AddWebinarScreen({super.key});

  @override
  State<AddWebinarScreen> createState() => _AddWebinarScreenState();
}

class _AddWebinarScreenState extends State<AddWebinarScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for the fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final maxParticipantsController = TextEditingController();
  final meetLinkController = TextEditingController();
  final dateController = TextEditingController();

  DateTime date = DateTime.now();

  Future<void> _addWebinar() async {
    final url = Uri.parse('http://10.0.2.2:3000/webinars');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': titleController.text,
          'description': descriptionController.text,
          'date': date.toIso8601String(),
          'duration': int.parse(durationController.text),
          'maxParticipants': int.parse(maxParticipantsController.text),
          'meetLink': meetLinkController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Webinar Added Successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add webinar: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date),
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    dateController.text = date.toLocal().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Webinar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date & Time'),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDateTimePicker(context);
                  if (picked != null) {
                    setState(() {
                      date = picked;
                      dateController.text = date.toLocal().toString();
                    });
                  }
                },
                validator: (value) {
                  return null;
                },
              ),
              TextFormField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: maxParticipantsController,
                decoration: const InputDecoration(labelText: 'Max Participants'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the max number of participants';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: meetLinkController,
                decoration: const InputDecoration(labelText: 'Meet Link'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the meet link';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addWebinar();
                  }
                },
                child: const Text('Add Webinar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    maxParticipantsController.dispose();
    meetLinkController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
