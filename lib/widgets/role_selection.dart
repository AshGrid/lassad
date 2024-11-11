import 'package:flutter/material.dart';

class RoleSelection extends StatelessWidget {
  final Function onStudentSelected;
  final Function onInstructorSelected;

  const RoleSelection({super.key, required this.onStudentSelected, required this.onInstructorSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width of the screen
      height: 750,
      alignment: Alignment.center,
      color:Colors.grey[200],
      child: Column(
        children: [
          Container(
            width: double.infinity, // Full width of the screen
            height: 150, // Adjust the height as needed
            alignment: Alignment.center, // Center the child inside the container
            child: Image.asset(
              'assets/images/moodle.png', // Replace with your image path
              height: 120, // Adjust height as necessary
            ),
          ),
          SizedBox(
            width: double.infinity, // Full width of the screen
            height: 60,
            child: Row(
              children: [
                const SizedBox(
                  width: 45,
                ),
                Text(
                  'Welcome to Moodle',
                  style: TextStyle (
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
          const Column(
            children: [
              SizedBox(width :20 , height:10),
              Row(
                children: [
                  SizedBox(width :63),
                  Text(
                    'Register as an Instructor\n         or as a Student.',
                    style: TextStyle (
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: double.infinity,
            height: 30,
          ),
          SizedBox(
            width: 250, // Fixed width for both buttons
            height: 50, // Fixed height for both buttons

            child: ElevatedButton(
              onPressed: () {
                onStudentSelected();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800 ], // Set button color to blue
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.white, // White text color
                  fontSize: 18
                ),
              ),
              child: const Text(
                'Register as a Student',
                style: TextStyle(color: Colors.white), // White text
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 250, // Fixed width for both buttons
            height: 50, // Fixed height for both buttons
            child: ElevatedButton(
              onPressed: () {
                onInstructorSelected();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800], // Set button color to blue
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.white, // White text color
                  fontSize: 18
                ),
              ),
              child: const Text(
                'Register as an Instructor',
                style: TextStyle(color: Colors.white), // White text
              ),
            ),
          ),
        ],
      ),
    );
  }
}
