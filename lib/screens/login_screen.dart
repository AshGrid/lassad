import 'package:flutter/material.dart';
import '/widgets/custom_appBar.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Loggin',
        isLoggedIn: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, // Full width of the screen
              height: 200, // Adjust the height as needed
              alignment: Alignment.center, // Center the child inside the container
              child: Image.asset(
                'assets/images/moodle.png', // Replace with your image path
                height: 120, // Adjust height as necessary
              ),
            ),
            const Text('Email', style: TextStyle(fontSize: 18)),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Password', style: TextStyle(fontSize: 18)),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blue[800]),
              )
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[800]),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Forgot Password'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Reset password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[800]),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
