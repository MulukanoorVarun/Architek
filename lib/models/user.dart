import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String userType;
  final List<String>? savedArchitects;
  final List<String>? savedProjects;
  final List<String>? projects;
  final String createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.userType,
    this.savedArchitects,
    this.savedProjects,
    this.projects,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    profileImage,
    userType,
    savedArchitects,
    savedProjects,
    projects,
    createdAt,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'userType': userType,
      'savedArchitects': savedArchitects,
      'savedProjects': savedProjects,
      'projects': projects,
      'createdAt': createdAt,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      userType: json['userType'],
      savedArchitects: json['savedArchitects'] != null
          ? List<String>.from(json['savedArchitects'])
          : null,
      savedProjects: json['savedProjects'] != null
          ? List<String>.from(json['savedProjects'])
          : null,
      projects: json['projects'] != null
          ? List<String>.from(json['projects'])
          : null,
      createdAt: json['createdAt'],
    );
  }
}