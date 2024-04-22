import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decoder/providers/user_data.dart'; 
import 'package:decoder/screens/user_settings.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  final user = auth.FirebaseAuth.instance.currentUser!;
  void _deleteUser() async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    
    await user.delete();
    
    // Sign out
    await auth.FirebaseAuth.instance.signOut();
  } catch (error) {
    print("An error occurred during account deletion: $error");
  }
}

  void _changeRole() async {
    ref.read(userDataProvider.notifier).changeRole(user.uid);
    await auth.FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final prUser = ref.watch(userDataProvider);

    Widget content;
    if (prUser == null) {
      content =
          const CircularProgressIndicator(); // Show loading indicator if user data is not yet fetched
    } else {
      content = Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                prUser.image != null ? FileImage(prUser.image!) : null,
            backgroundColor: Colors
                .transparent, // Show transparent background if image is null
          ),
          const SizedBox(height: 15),
          Text(
            '${prUser.firstName} ${prUser.lastName}', // Use fetched firstName
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
        ],
      );
    }

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [content],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'Account settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 20),
            ),
            onTap: () {
              if (prUser != null) {
                // Ensure prUser is not null before navigating
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => UserSettingsScreen(
                      userModel: prUser,
                    ),
                  ),
                );
              }
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.change_circle),
            title: Text(
              'Change role',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 20),
            ),
            onTap: () {
              _changeRole();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Durations.long4,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  content: Text(
                    "Role changed! Please log in",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: Text(
              'Delete Account',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.error, fontSize: 20),
            ),
            onTap: () {
              if (Platform.isIOS) {
                showCupertinoDialog(
                    context: context,
                    builder: (ctx) {
                      return CupertinoAlertDialog(
                        title: const Text(
                          'Deleting user',
                        ),
                        content: const Text(
                          'Are you sure you want to delete account?',
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'No',
                              )),
                          TextButton(
                            onPressed: () {
                              _deleteUser();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  content: Text(
                                    "Account deleted",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Yes',
                            ),
                          )
                        ],
                      );
                    });
                return;
              } else {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        title: Text(
                          'Deleting user',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                            'Are you sure you want to delete account?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer)),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        fontWeight: FontWeight.bold),
                              )),
                          TextButton(
                            onPressed: () {
                              _deleteUser();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  content: Text(
                                    "Account deleted",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Yes',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      );
                    });
                return;
              }
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(
              'Log out',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 20),
            ),
            onTap: () => auth.FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
    );
  }
}
