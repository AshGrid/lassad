import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userName = 'Username';
  String userRole = 'Role';
  File? profileImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
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
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        profileImage = File(imagePath);
      }

      // Set loading to false once data is loaded
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff003a96), Color(0xff001b45)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SizedBox.expand(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    profileImage != null
                        ? CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      backgroundImage: FileImage(profileImage!),
                    )
                        : const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/moodle.png'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      userRole,
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.person,
            text: 'Profile',
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildDrawerItem(
            icon: Icons.video_library, // Icon for the module
            text: 'Round Tables & Webinars', // Title in English
            onTap: () {
              Navigator.pushNamed(context, '/roundTablesWebinars');
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
          ),

          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Clear all saved data

              // Navigate to the LoginScreen and remove all previous routes
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),

        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blue[900],
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.teal[600]?.withOpacity(0.1),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}
