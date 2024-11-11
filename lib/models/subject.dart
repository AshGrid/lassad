import 'package:json_annotation/json_annotation.dart';
import 'chapter.dart';

part 'subject.g.dart'; // This is used for JSON serialization support

@JsonSerializable()
class Subject {
  final String? id; // Unique identifier for the subject
  final String? name; // Subject name
  final List<Chapter?> chapters; // List of chapter IDs


  Subject({
    required this.id,
    required this.name,
    required this.chapters,

  });

  // Factory method to create a Subject instance from JSON
  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);

  // Method to convert Subject instance to JSON
  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}
