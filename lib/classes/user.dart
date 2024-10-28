import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart'; // This is used for JSON serialization support

@JsonSerializable()
class User {
  final String? id; // Unique identifier for the user
  final String? username; // User's username
  final String? email; // User's email address
  final String? password; // User's password (consider hashing this before saving)
  final String? institution; // User's institution
  final String? role; // User's role (Student or Instructor)
  final String? profilePicture; // URL or file path for profile picture
  final List<String>? subjects; // List of subject names or IDs for students
  final String? affiliatedSubject; // Name or ID of the affiliated subject for instructors

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.institution,
    required this.role,
    this.profilePicture,
    this.subjects,
    this.affiliatedSubject,
  });

  // Factory method to create a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Method to convert User instance to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
