import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class AllUsersNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  AllUsersNotifier() : super([]);

  void getAllUsersFromFirestore() async {
    File? imageFile;
    final users = await FirebaseFirestore.instance.collection('users').get();
    for (var doc in users.docs) {
      Map<String, dynamic> map = doc.data();
      imageFile = await _urlToFile(doc.data()['image_url']);
      final idEntry = <String, dynamic>{'id': doc.id};
      final imageEntry = <String, dynamic>{'image': imageFile};
      map.addEntries(idEntry.entries);
      map.addEntries(imageEntry.entries);
      print(map);
      state = [...state, map];
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

final allUsersProvider =
    StateNotifierProvider<AllUsersNotifier, List<Map<String, dynamic>>>((ref) {
  return AllUsersNotifier();
});
