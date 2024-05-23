import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String text = '';
    void saveNote() {
      var isValid = formKey.currentState!.validate();

      if (!isValid) {
        return;
      }
      formKey.currentState!.save();

      Navigator.of(context).pop({'title': title, 'text': text});
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Note',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Use minimum space
                    children: <Widget>[
                      TextFormField(
                        maxLength: 50,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                        decoration: InputDecoration(
                          labelText: 'Note title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onSaved: (newValue) {
                          title = newValue!;
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Error: Empty field';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                    decoration: const InputDecoration(
                      labelText: 'Note body',
                      border: OutlineInputBorder(),
                      hintText: 'Type your note here...',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      text = newValue!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: saveNote,
                  child: const Text('Submit'),
                )
              ],
            ),
          ),
        ));
  }
}
