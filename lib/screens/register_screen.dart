import 'package:flutter/material.dart';
import '/widgets/role_selection.dart';
import '/widgets/signup_form.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String role = ''; // Role attribute (student or instructor)

  void onRegister(String email, String password) {
    // Handle the registration logic here
    // For example, you can navigate to another screen or show a success message
    print('Registered as $role with email: $email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (role.isEmpty)
              RoleSelection(
                onStudentSelected: () {
                  setState(() {
                    role = 'student';
                  });
                },
                onInstructorSelected: () {
                  setState(() {
                    role = 'instructor';
                  });
                },
              ),
            if (role.isNotEmpty)
              SignUpForm(
                role: role,
                onRegister: onRegister,
              ),
          ],
        ),
      ),
    );
  }
}
