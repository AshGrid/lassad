import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/widgets/custom_appBar.dart';
import '/widgets/custom_drawer.dart';
import 'dart:io';
import '/services/user_service.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditingName = false;
  bool isEditingEmail = false;
  bool isEditingPhone = false;
  bool isEditingInstitution = false;
  bool isSaving = false;

  String userId = '';
  String userName = 'username';
  String userEmail = 'username@example.com';
  String userPhone = '28 000 000';
  String institution = 'ESPRIT';
  File? profileImage;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('SharedPreferences data:');
    prefs.getKeys().forEach((key) {
      print('$key: ${prefs.get(key)}');
    });

    setState(() {
      String? userJson = prefs.getString('user');
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        userId = userData['_id'] ?? '';
        userName = userData['username'] ?? 'username';
        userEmail = userData['email'] ?? 'username@example.com';
        userPhone = userData['phone'] ?? '28 000 000';
        institution = userData['institution'] ?? 'ESPRIT';
      }

      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        profileImage = File(imagePath);
      }
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', pickedFile.path);
    }
  }

  Future<void> saveChanges() async {
    setState(() {
      isSaving = true;
    });

    final bool success = await _authService.modifyUser(
      userId,
      userName,
      userEmail,
      userPhone,
      institution,
      null,
      profileImage != null ? XFile(profileImage!.path) : null,
    );

    if (success) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> updatedUserData = {
        '_id': userId,
        'username': userName,
        'email': userEmail,
        'phone': userPhone,
        'institution': institution,
      };

      await prefs.setString('user', jsonEncode(updatedUserData));
    }

    setState(() {
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'User profile updated successfully'
            : 'Failed to update profile'),
      ),
    );

    if (success) {
      loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'User Profile',
        isLoggedIn: true,
        userImageUrl: 'assets/images/moodle.png', backgroundColor: Color(0x3200ff),
      ),
      endDrawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange.shade300,
                    radius: 60,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : const AssetImage('assets/images/moodle.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Icon(Icons.camera_alt, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildEditableField(
                'Name', userName, isEditingName, (value) => setState(() => userName = value)),
            ListTile(
              leading: Icon(Icons.badge, color: Colors.blue[900]),
              title: const Text('Role', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text('Student'),
            ),
            _buildEditableField(
                'Email', userEmail, isEditingEmail, (value) => setState(() => userEmail = value)),
            _buildEditableField(
                'Phone Number', userPhone, isEditingPhone, (value) => setState(() => userPhone = value)),
            _buildEditableField(
                'Institution', institution, isEditingInstitution, (value) => setState(() => institution = value)),

            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSaving ? null : saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Save Changes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String title, String value, bool isEditing, Function(String) onChanged) {
    return ListTile(
      leading: Icon(_getIconForTitle(title), color: Colors.blue[900]),
      title: isEditing
          ? TextFormField(
        initialValue: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(color: Colors.blue.shade900),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade900),
          ),
        ),
      )
          : Text(value, style: const TextStyle(fontSize: 16)),
      trailing: IconButton(
        icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.blue[900]),
        onPressed: () => setState(() {
          if (isEditing) {
            onChanged(value);
          }
          _toggleEditField(title);
        }),
      ),
    );
  }

  void _toggleEditField(String field) {
    setState(() {
      if (field == 'Name') isEditingName = !isEditingName;
      if (field == 'Email') isEditingEmail = !isEditingEmail;
      if (field == 'Phone Number') isEditingPhone = !isEditingPhone;
      if (field == 'Institution') isEditingInstitution = !isEditingInstitution;
    });
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Name':
        return Icons.person;
      case 'Email':
        return Icons.email;
      case 'Phone Number':
        return Icons.phone;
      case 'Institution':
        return Icons.school;
      default:
        return Icons.info;
    }
  }
}
