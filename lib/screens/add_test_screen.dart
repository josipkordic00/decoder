import 'package:decoder/models/task.dart';
import 'package:decoder/screens/add_question_screen.dart';
import 'package:decoder/widgets/question_section.dart';
import 'package:flutter/material.dart';

class AddTestScreen extends StatefulWidget {
  const AddTestScreen({super.key});

  @override
  State<AddTestScreen> createState() => _AddTestScreenState();
}

class _AddTestScreenState extends State<AddTestScreen> {
  final questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Error: Empty field';
                }
                return null;
              },
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                label: Text(
                  'Test title',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ),
            ListTile(
              title: const Text('Add Question'),
              onTap: () async {
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (ctx) => const AddQuestionScreen()));
                setState(() {
                  questions.add(result);
                });
              },
              leading: const Icon(Icons.add),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return QuestionSection(map: questions[index]);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  print(questions);
                },
                child: const Text('Submit test')),
            Text(
              'Swipe for deleting item',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5)),
            )
          ],
        ),
      ),
    );
  }
}
