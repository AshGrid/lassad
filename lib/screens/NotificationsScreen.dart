import 'package:flutter/material.dart';
import '../widgets/Bottom_navigation.dart'; // Make sure this path is correct
import '../widgets/custom_appBar.dart'; // Make sure this path is correct

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample notifications data
  final List<String> notifications = [
    "Your order has been shipped!",
    "New message from John Doe",
    "Reminder: Meeting at 3 PM",
    "Your profile was updated successfully",
    "Don't miss the sale! 50% off on selected items.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(notifications[index]),
                // You can add a trailing icon or any other widget here if needed
              ),
            );
          },
        ),
      ),
    );
  }
}
