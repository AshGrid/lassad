import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_app/classes/subject.dart';

part 'chapter.g.dart';

@JsonSerializable()
class Chapter {
  final String? id; // This will be the unique identifier from MongoDB
  final String? name;
  final String? pdfFile;
  final String? subject; // The ObjectId of the subject as a String

  Chapter({
    required this.id,
    required this.name,
    required this.pdfFile,
    required this.subject,
  });

  // Factory constructor to create a Chapter from JSON
  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);

  // Method to convert a Chapter instance to JSON
  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}
