import 'package:flutter/material.dart';

class TestSection extends StatelessWidget {
  const TestSection({super.key, required this.title, required this.data});

  final String title;
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.errorContainer.withAlpha(255),
              Theme.of(context).colorScheme.errorContainer.withOpacity(0.5)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListTile(
            leading: Icon(
              Icons.assignment_add,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
        ),
      ),
    );
  }
}
