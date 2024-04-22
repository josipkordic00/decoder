import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decoder/models/user.dart';
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

      // Assuming you have a User model that includes the role and other details

      print('state updated to ${roles[0]}');
    } catch (e) {
      // Handle errors, e.g., print them or use a state to show an error message
      print("Error updating user role: $e");
    }
  }

  void getFromFirestore(String userId) async {
    try {
      //print('Fetching user data for $userId'); // Log the attempt to fetch
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        File? imageFile;
        if (data['image_url'] != null) {
          imageFile = await _urlToFile(data['image_url']);
        }
        //print('User data fetched successfully'); // Log successful fetch
        state = UserModel(
            firstName: data['first_name'],
            lastName: data['last_name'],
            email: data['email'],
            image: imageFile,
            role: data['role']);
        //print('State updated with user data $data'); // Log state update
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<File> _urlToFile(String imageUrl) async {
    final uri = Uri.parse(imageUrl);
    final response = await http.get(uri);

    final directory = await getApplicationDocumentsDirectory();
    final imagesDirectoryPath = '${directory.path}/user_profile_images';
    final imagesDirectory = Directory(imagesDirectoryPath);

    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }

    final filePath =
        '${imagesDirectory.path}/${Uri.encodeComponent(uri.pathSegments.last)}';
    final file = File(filePath);
    //print("Saving file to: $filePath");

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }
}

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, UserModel?>((ref) {
  return UserDataNotifier();
});
