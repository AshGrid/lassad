class UserModel {
  String uid;
  String email;
  String username;
  String role;
  String institution;
  String profilePicture;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.role,
    this.institution = '',
    this.profilePicture = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'role': role,
      'institution': institution,
      'profilePicture': profilePicture,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      role: map['role'] ?? '',
      institution: map['institution'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
    );
  }
}
