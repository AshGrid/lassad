// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      institution: json['institution'] as String?,
      role: json['role'] as String?,
      profilePicture: json['profilePicture'] as String?,
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      affiliatedSubject: json['affiliatedSubject'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'institution': instance.institution,
      'role': instance.role,
      'profilePicture': instance.profilePicture,
      'subjects': instance.subjects,
      'affiliatedSubject': instance.affiliatedSubject,
    };
