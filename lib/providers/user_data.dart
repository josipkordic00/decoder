import 'package:decoder/models/user.dart';

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UserDataNotifier extends StateNotifier<UserModel?> {
  UserDataNotifier() : super(null);

  void changeRole(String userId) async {
    List<String> roles = ['Student', 'Instructor'];

    if (roles.contains(state!.role)) {
      roles.remove(state!.role);
    }

    try {
      if (state != null) {
        // Update the local state with the new role
        state = UserModel(
            firstName: state!.firstName,
            lastName: state!.lastName,
            email: state!.email,
            image: state!.image,
            role: roles[0].toString());
      }
      // Update the user's role in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': roles[0],
      });
    } catch (e) {
      print("Error updating user role: $e");
    }
  }

  void getFromFirestore(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        print('No user found for ID: $userId');
        return;
      }

      final data = doc.data()!;
      File? imageFile = data['image_url'] != null
          ? await _urlToFile(data['image_url'])
          : null;

      state = UserModel(
          firstName: data['first_name'],
          lastName: data['last_name'],
          email: data['email'],
          image: imageFile,
          role: data['role']);
    } catch (e) {
      print("Error fetching user data: $e");
    }
    
  }

  Future<File> _urlToFile(String imageUrl) async {
    final uri = Uri.parse(imageUrl);
    final directory = await getApplicationDocumentsDirectory();
    final imagesDirectoryPath = '${directory.path}/user_profile_images';
    final imagesDirectory = Directory(imagesDirectoryPath);

    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }

    final filePath =
        '${imagesDirectory.path}/${Uri.encodeComponent(uri.pathSegments.last)}';
    final file = File(filePath);

    if (await file.exists()) {
      return file;
    }

    try {
      final response = await http.get(uri);
      await file.writeAsBytes(response.bodyBytes);
      print("File saved: $filePath");
    } catch (e) {
      print("Failed to download image: $e");
      // Optionally, handle the error e.g., by returning a default image
    }

    return file;
  }
}

final courseImageProvider =
    Provider.family<ImageProvider, String>((ref, imageUrl) {
  return NetworkImage(imageUrl);
});

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, UserModel?>((ref) {
  return UserDataNotifier();
});
