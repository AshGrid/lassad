import 'package:flutter/material.dart';
import 'package:moodle_app/screens/HomePage.dart'; // Ensure this path is correct
import '../widgets/Bottom_navigation.dart';
import '/widgets/custom_appBar.dart';
import 'CoursesScreen.dart';
import 'NotificationsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index for the bottom navigation


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index when tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        isLoggedIn: true,
        userImageUrl: 'assets/images/moodle.png',
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
              child: const Text('User Name', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const ListTile(
              title: Text('Profile'),
            ),
            const ListTile(
              title: Text('Settings'),
            ),
            // Add more options here
          ],
        ),
      ),
      body: _getPage(_selectedIndex), // Display the selected page
      bottomNavigationBar: Container(
        height: 84,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: BottomNavigation(
            currentIndex: _selectedIndex, // Pass the current index to the BottomNavigation widget
            onTap: _onItemTapped, // Call the method when an item is tapped
          ),
        ),
      ),
    );
  }

  Widget _getPage(int selectedIndex) {
    // Return the selected index page
    switch (selectedIndex) {
      case 0:
        return const HomePScreen(); // Ensure this screen exists and is imported
      case 1:
        return const CoursesScreen(); // Ensure this screen exists and is imported
      case 2:
        return const NotificationScreen(); // Ensure this screen exists and is imported
      default:
        return const SizedBox(); // Default to an empty box
    }
  }
}
