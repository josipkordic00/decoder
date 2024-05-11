import 'package:decoder/providers/user_data.dart';
import 'package:decoder/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  'Edit profile image',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 20),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.edit_document),
                title: Text(
                  'Edit profile name',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 20),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
