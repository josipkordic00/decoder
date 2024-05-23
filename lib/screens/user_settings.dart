import 'dart:io';

import 'package:decoder/providers/user_data.dart';
import 'package:decoder/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UserSettingsScreen extends ConsumerStatefulWidget {
  const UserSettingsScreen({super.key, required this.userModel});

  final UserModel userModel;
  @override
  ConsumerState<UserSettingsScreen> createState() {
    return _UserSettingsScreenState();
  }
}

class _UserSettingsScreenState extends ConsumerState<UserSettingsScreen> {
  var user = FirebaseAuth.instance.currentUser!;
  File? _pickedProfileImage;
  final TextEditingController passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void _pickCameraImage() async {
    final _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (_pickedImage == null) {
      return;
    }
    setState(() {
      _pickedProfileImage = File(_pickedImage.path);
    });
  }

  void _pickGalleryImage() async {
    final _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_pickedImage == null) {
      return;
    }
    setState(() {
      _pickedProfileImage = File(_pickedImage.path);
    });
  }

  void _updatePassword() async {
    var isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    User? user = auth.currentUser;
    String newPassword = passwordController.text;

    try {
      print('started');
      await user!.updatePassword(newPassword);
      passwordController.clear();
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
            "Password changed",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onTertiary),
          ),
        ),
      );
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            passwordController.clear();
            return AlertDialog(
              title: const Text("Re-authentication required"),
              content: const Text(
                  "Please re-enter your old password to confirm it's you."),
              actions: <Widget>[
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                ),
                TextButton(
                  child: const Text("Confirm"),
                  onPressed: () async {
                    // Close the dialog
                    User? user = auth.currentUser;
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: user!.email!,
                      password: passwordController.text,
                    );

                    user.reauthenticateWithCredential(credential).then((_) {
                      _updatePassword(); // Try updating the password again
                    }).catchError((error) {
                      print('Re-authentication failed: $error');
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Password update failed: $e');
      }
    }
  }

  void _changePassword() {
    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 16,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use minimum space
                children: <Widget>[
                  Form(
                    key: _form,
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.length < 6) {
                          return 'Minimal length is 6 characters';
                        }
                        return null;
                      },
                      autocorrect: false,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                      decoration: InputDecoration(
                        hintText: 'New password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _updatePassword,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String name = '${widget.userModel.firstName} ${widget.userModel.lastName}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: widget.userModel.image != null
                      ? FileImage(widget.userModel.image!)
                      : null,
                  backgroundColor: Colors
                      .transparent, // Show transparent background if image is null
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ref.watch(userDataProvider)!.role,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: const Icon(Icons.edit_document),
                  title: Text(
                    'Change password',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontSize: 20),
                  ),
                  onTap: _changePassword,
                ),
                ListTile(
                  leading: const Icon(Icons.edit_document),
                  title: Text(
                    'Edit profile photo',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontSize: 20),
                  ),
                  onTap: () {},
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
