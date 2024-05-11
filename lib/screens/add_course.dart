import 'package:decoder/models/lesson.dart';
import 'package:decoder/models/note.dart';
import 'package:decoder/screens/add_note.dart';
import 'package:decoder/widgets/lesson_section.dart';
import 'package:decoder/widgets/note_section.dart';
import 'package:decoder/widgets/test_section.dart';

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddCourseScreen extends ConsumerStatefulWidget {
  const AddCourseScreen({super.key});

  @override
  ConsumerState<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends ConsumerState<AddCourseScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController titleTestController = TextEditingController();
  final TextEditingController linkLessonController = TextEditingController();
  bool showError = false;
  bool _isUpdating = false;
  List<dynamic> sectionsList = [];
  File? _pickedProfileImage;
  final _form = GlobalKey<FormState>();
  var _enteredName = '';
  final _user = FirebaseAuth.instance.currentUser;

  void _publishCourse() async {
    var isValid = _form.currentState!.validate();

    if (!isValid || _pickedProfileImage == null || sectionsList.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            "Add course image and at least 1 lesson/test/note.",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer),
          ),
        ),
      );
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isUpdating = true;
    });
    var addedLessons = sectionsList.whereType<LessonSection>().toList();
    var addedTests = sectionsList.whereType<TestSection>().toList();
    var addedNotes = sectionsList.whereType<NoteSection>().toList();
    List<dynamic> firestoreLessons = [];
    List<dynamic> firestoreNotes = [];
    List<String> firestoreTests = [];

    for (var i in addedLessons) {
      String title = i.title;
      String? videoUrl = YoutubePlayer.convertUrlToId(i.videoID);
      Lesson lesson = Lesson(title: title, url: videoUrl!, learned: []);
      firestoreLessons.add(lesson.toMap());
    }
    for (var i in addedNotes) {
      String title = i.title;
      String text = i.text;
      Note note = Note(title: title, text: text);
      firestoreNotes.add(note.toMap());
    }
    for (var i in addedTests) {
      firestoreTests.add(i.title);
    }
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('course_images')
          .child('${_enteredName}_${_user!.uid}.jpg');
      await storageRef.putFile(_pickedProfileImage!);

      //save course data in firestore
      final imageURL = await storageRef.getDownloadURL();
      var firestoreInstance = FirebaseFirestore.instance;
      var userId = _user.uid;
      var courseId = firestoreInstance.collection('courses').doc().id;

      await firestoreInstance.collection('courses').doc(courseId).set({
        'name': _enteredName,
        'image_url': imageURL,
        'user_id': userId,
        'tests': firestoreTests,
        'createdAt': Timestamp.now(),
        'enrolled_users': [userId]
      }, SetOptions(merge: true));
      for (var lesson in firestoreLessons) {
        await firestoreInstance
            .collection('courses')
            .doc(courseId)
            .collection('lessons')
            .add(lesson);
      }
      for (var note in firestoreNotes) {
        await firestoreInstance
            .collection('courses')
            .doc(courseId)
            .collection('notes')
            .add(note);
      }
      setState(() {
        _isUpdating = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          content: Text(
            "Course added.",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onTertiaryContainer),
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            "$err, Publishing failed.",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer),
          ),
        ),
      );
    }
  }

  void _addNewTest() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use minimum space
              children: <Widget>[
                TextFormField(
                  controller: titleTestController,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                    errorText: showError ? 'Please enter a title' : null,
                    hintText: 'Enter test title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    if (titleTestController.text.isEmpty) {
                      // If text is empty, update the state to show error
                      setState(() {
                        showError = true; // Enable error message display
                      });
                    } else {
                      setState(() {
                        sectionsList
                            .add(TestSection(title: titleTestController.text));
                        showError = false;
                      });
                      titleTestController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addNewNote() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const AddNoteScreen()));
    print(result);
    if (result != null) {
      setState(() {
        sectionsList.add(NoteSection(
          title: result['title'],
          text: result['text'],
        ));
      });
    }
  }

  void _pickGalleryImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedProfileImage = File(pickedImage.path);
    });
  }

  void _addNewLesson() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use minimum space
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                    errorText: showError ? 'Please enter a title' : null,
                    hintText: 'Enter lesson title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: linkLessonController,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                    errorText: showError ? 'Please paste youtube link' : null,
                    hintText: 'Enter lesson youtube link',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        linkLessonController.text.isEmpty) {
                      // If text is empty, update the state to show error
                      setState(() {
                        showError = true; // Enable error message display
                      });
                    } else {
                      setState(() {
                        sectionsList.add(
                          LessonSection(
                            title: titleController.text,
                            videoID: linkLessonController.text,
                          ),
                        );

                        showError =
                            false; // Reset error state on successful input
                      });
                      titleController.clear();
                      linkLessonController.clear();
                      Navigator.of(context)
                          .pop(); // Dismiss the dialog after saving
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageContent = Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondaryContainer,
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: _pickGalleryImage,
            icon: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            label: Text(
              'Add course image',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );

    Widget profileImageWidget = _pickedProfileImage == null
        ? imageContent
        : SizedBox(
            width: double.infinity,
            height: 200,
            child: Image.file(_pickedProfileImage!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add course'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: _form,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Error: Empty field';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredName = newValue!;
                      },
                      autocorrect: false,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Course name',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        prefixIcon: Icon(
                          Icons.play_circle,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                profileImageWidget,
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Course content',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text(
                    'Add new lesson',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  leading: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onTap: _addNewLesson,
                ),
                ListTile(
                  title: Text(
                    'Add new test',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  leading: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onTap: _addNewTest,
                ),
                ListTile(
                  title: Text(
                    'Add new note',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  leading: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onTap: _addNewNote,
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sectionsList.length,
                    itemBuilder: (ctx, index) {
                      return sectionsList[index];
                    }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 70, 49, 128),
              Color.fromARGB(255, 0, 10, 117)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: InkWell(
          onTap: _publishCourse,
          borderRadius: BorderRadius.circular(30),
          child: const Icon(
            Icons.upload,
            color: Colors.white,
            size: 27,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
