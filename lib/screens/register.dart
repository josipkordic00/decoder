import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

final _firebase = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  File? _pickedProfileImage;

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _firstName = '';
  var _lastName = '';
  var _isAuthenticating = false;

//submit registered user inputs on firebase
  void _submit() async {
    var isValid = _form.currentState!.validate();

    if (!isValid || _pickedProfileImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            "Image or form aren't filled out correctly.",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer),
          ),
        ),
      );
      return;
    }

    _form.currentState!.save();
    FocusScope.of(context).unfocus();

    try {
      //spinner active
      setState(() {
        _isAuthenticating = true;
      });
      //create user with email and passwrd and sign in
      final _userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      //save profile image in storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child('${_userCredentials.user!.uid}.jpg');
      await storageRef.putFile(_pickedProfileImage!);

      //save user data in firestore
      final imageURL = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userCredentials.user!.uid)
          .set({
        'email': _enteredEmail,
        'image_url': imageURL,
        'first_name': _firstName,
        'last_name': _lastName,
        'role': 'Student',
      });
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (err) {
      //stop spinner and show error in snackbar
      setState(() {
        _isAuthenticating = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            "${err.message}, Authentication failed.",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer),
          ),
        ),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    //image picker container
    Widget imageContent = Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
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
            onPressed: _pickCameraImage,
            icon: Icon(
              Icons.camera,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            label: Text(
              'Take profile photo',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
          ),
          TextButton.icon(
            onPressed: _pickGalleryImage,
            icon: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            label: Text(
              'Add from gallery',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );

//show image in container if is selected
    Widget profileImageWidget = _pickedProfileImage == null
        ? imageContent
        : CircleAvatar(
            radius: 100,
            foregroundImage: FileImage(_pickedProfileImage!),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create account',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 15),
            child: Form(
                key: _form,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Error: Empty field';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  _firstName = newValue!;
                                });
                              },
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 26, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                label: Text(
                                  'First name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Error: Empty field';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  _lastName = newValue!;
                                });
                              },
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 26, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                label: Text(
                                  'Last name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        label: Text(
                          'Email',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter valid e-mail address';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredEmail = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      obscureText: true,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        label: Text(
                          'Password',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password length must be at least 6';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredPassword = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //show image based on state
                    profileImageWidget,
                    const SizedBox(
                      height: 30,
                    ),
                    _isAuthenticating
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 50),
                              ),
                            ),
                            onPressed: _submit,
                            child: Text(
                              'Sign up',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have account?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Sign in',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
