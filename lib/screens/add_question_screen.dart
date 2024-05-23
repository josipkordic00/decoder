import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController answerController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  var _selectedType = "Multiple choice";
  var showError = false;
  var showErrorQ = false;
  var showErrorMC = false;
  var _correctAnswer = "";
  final List<String> _addedAnswers = [];

  void _addAnswer() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                  mainAxisSize: MainAxisSize.min, // Use minimum space
                  children: <Widget>[
                    TextFormField(
                      controller: answerController,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                      decoration: InputDecoration(
                        errorText: showError ? 'Error' : null,
                        hintText: 'Answer...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        if (answerController.text.isEmpty ||
                            _addedAnswers.contains(answerController.text)) {
                          setState(() {
                            showError = true;
                          });
                        } else {
                          Navigator.of(context).pop(answerController.text);
                          answerController
                              .clear(); // Dismiss the dialog after saving
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ]);
            }),
          ),
        );
      },
    );
    print(result);
    setState(() {
      showError = false;
      _addedAnswers.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: questionController,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
              decoration: InputDecoration(
                errorText: showErrorQ ? 'Please add question' : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                label: Text(
                  'Question',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Answer type: ',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                DropdownButton(
                    value: _selectedType,
                    items: [
                      DropdownMenuItem(
                        value: 'Multiple choice',
                        child: Text(
                          'Multiple Choice',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      ),
                      DropdownMenuItem(
                          value: 'True/false',
                          child: Text(
                            'True/False',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          )),
                      DropdownMenuItem(
                        value: 'Textual Answer',
                        child: Text(
                          'Textual Answer',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      )
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedType = value;
                      });
                    }),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            _selectedType != "Textual Answer"
                ? Expanded(
                    child: _selectedType == "Multiple choice"
                        ? Column(
                            children: [
                              ListTile(
                                title: const Text('Add answer'),
                                leading: const Icon(Icons.add),
                                onTap: _addAnswer,
                              ),
                              showErrorMC
                                  ? Text(
                                      'Add answer',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                    )
                                  : const SizedBox(
                                      height: 5,
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _addedAnswers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(_addedAnswers[index]),
                                      leading:
                                          _addedAnswers[index] == _correctAnswer
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.check_circle_rounded,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _correctAnswer =
                                                          _addedAnswers[index];
                                                    });
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _correctAnswer =
                                                          _addedAnswers[index];
                                                    });
                                                  },
                                                ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        onPressed: () {
                                          if (_correctAnswer ==
                                              _addedAnswers[index]) {
                                            _correctAnswer = "";
                                          }
                                          setState(() {
                                            _addedAnswers
                                                .remove(_addedAnswers[index]);
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                'Correct answer:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              ),
                              ListTile(
                                title: const Text('True'),
                                leading: 'True' == _correctAnswer
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.check_circle_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _correctAnswer = "True";
                                          });
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _correctAnswer = "True";
                                          });
                                        },
                                      ),
                              ),
                              ListTile(
                                title: const Text('False'),
                                leading: 'False' == _correctAnswer
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.check_circle_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _correctAnswer = "False";
                                          });
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _correctAnswer = "False";
                                          });
                                        },
                                      ),
                              ),
                            ],
                          ),
                  )
                : const SizedBox(),
            ElevatedButton(
                onPressed: () {
                  if (questionController.text.trim().isEmpty) {
                    setState(() {
                      showErrorQ = true;
                    });
                    return;
                  }
                  if (_selectedType == "Multiple choice" &&
                      _addedAnswers.length < 2 &&
                      _correctAnswer.isEmpty) {
                    print(_addedAnswers);
                    setState(() {
                      showErrorMC = true;
                    });
                    return;
                  }
                  showErrorQ = false;
                  showErrorMC = false;
                  Navigator.of(context).pop({
                    'question': questionController.text,
                    'type': _selectedType,
                    'answers': _addedAnswers,
                    'correct_Answer': _correctAnswer
                  });
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
