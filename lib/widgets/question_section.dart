import 'package:flutter/material.dart';

class QuestionSection extends StatelessWidget {
  const QuestionSection({super.key, required this.map});

  final Map<String, dynamic> map;

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
              Theme.of(context).colorScheme.primaryContainer.withAlpha(255),
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListTile(
            leading: Icon(
              Icons.assignment_add,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            title: Text(
              map['question'],
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            subtitle: Text(map['type']),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
