import 'package:flutter/material.dart';

class OwnedCoursesScreen extends StatefulWidget {
  const OwnedCoursesScreen({super.key});

  @override
  State<OwnedCoursesScreen> createState() => _OwnedCoursesScreenState();
}

class _OwnedCoursesScreenState extends State<OwnedCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owned courses'),
      ),
    );
  }
}
