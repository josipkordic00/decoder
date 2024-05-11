import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class AllUsersNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  AllUsersNotifier() : super([]);

  void getAllUsersFromFirestore() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<Future<Map<String, dynamic>>> userFutures =
        usersSnapshot.docs.map((doc) async {
      var userMap = doc.data();
      File? imageFile = await _urlToFile(userMap['image_url']);
      userMap['id'] = doc.id;
      userMap['image'] = imageFile;
      return userMap;
    }).toList();

    // Execute all futures in parallel and wait for them to complete
    List<Map<String, dynamic>> users = await Future.wait(userFutures);
    state = users;
  }

  

  Future<File> _urlToFile(String imageUrl) async {
    final uri = Uri.parse(imageUrl);
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/user_profile_images/${Uri.encodeComponent(uri.pathSegments.last)}';
    final file = File(filePath);

    // Check if file already exists to avoid re-downloading
    if (await file.exists()) {
      return file;
    }

    // Download only if the file does not exist
    final response = await http.get(uri);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
}

final allUsersProvider =
    StateNotifierProvider<AllUsersNotifier, List<Map<String, dynamic>>>((ref) {
  return AllUsersNotifier();
});
