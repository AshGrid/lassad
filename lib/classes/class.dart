import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_app/classes/subject.dart';
import 'package:moodle_app/classes/user.dart';

part 'class.g.dart'; // This is used for JSON serialization support

@JsonSerializable()
class Class {
  final String? id; // Unique identifier for the class
  final String? name; // Class name
  final List<User?> students; // List of student IDs
  final List<Subject?> subjects;
  Class({
    required this.id,
    required this.name,
    required this.students,
    required this.subjects,
  });

  // Factory method to create a Class instance from JSON
  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);

  // Method to convert Class instance to JSON
  Map<String, dynamic> toJson() => _$ClassToJson(this);
}
