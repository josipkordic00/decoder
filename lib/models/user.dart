import 'dart:io';

class UserModel {
  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.image,
    required this.role
  });

  final String firstName;
  final String lastName;
  final String email;
  final File? image;
  final String role;
}
