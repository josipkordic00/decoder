import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decoder/models/course.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SingleCourse extends StatefulWidget {
  const SingleCourse({super.key, required this.course});

  final Course course;
  @override
  State<SingleCourse> createState() {
    return _SingleCourseState();
  }
}

class _SingleCourseState extends State<SingleCourse> {
  bool onTapVideo = false;
  String? _lessonId;
  final Set<int> _tappedTiles = <int>{};
  bool lectureLearned = false;
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '1q5WyvYdpJQ',
    flags:const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  var _selectedRowItem = true;

  void _lessonVideo(String url) {
    _controller.load(url);
    setState(() {
      onTapVideo = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            onTapVideo
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      onEnded: (metaData) {
                        setState(() {
                          onTapVideo = false;
                          var lessonDocRef = FirebaseFirestore.instance
                              .collection('courses')
                              .doc(widget.course.id)
                              .collection('lessons')
                              .doc(_lessonId);

                          // Update the lesson
                          lessonDocRef
                              .update({'learned': true})
                              .then(
                                  (_) => print("Lesson updated successfully."))
                              .catchError((error) =>
                                  print("Error updating lesson: $error"));
                        });
                      },
                    ),
                  )
                : Hero(
                    tag: widget.course.id,
                    child: Image.network(
                      widget.course.image!,
                      height: 300,
                      width: double.infinity,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Row(
                children: [
                  InkWell(
                    splashColor: Theme.of(context).colorScheme.background,
                    highlightColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                      child: Text(
                        'Lessons',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: _selectedRowItem
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedRowItem = true;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    splashColor: Theme.of(context).colorScheme.background,
                    highlightColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                      child: Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: !_selectedRowItem
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedRowItem = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            //listview.builder or about / based on selected row item
            _selectedRowItem
                ? Expanded(
                    child: ListView.builder(
                      itemCount: widget.course.lessons.length,
                      itemBuilder: (context, index) {
                        bool isTapped = _tappedTiles.contains(index);
                        var data = widget.course.lessons;
                        return ListTile(
                            onTap: () {
                              setState(() {
                                if (_tappedTiles.contains(index)) {
                                  _tappedTiles.remove(index);
                                } else {
                                  _tappedTiles.clear();
                                  _tappedTiles.add(index);
                                  _lessonId = data[index].id;


                              _lessonVideo(data[index].url);
                                }
                              });
                            },
                            leading: Icon(
                              Icons.ondemand_video_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            title: Text(
                              data[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                            tileColor: isTapped
                                ? Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.1)
                                : null,
                            trailing: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('courses')
                                    .doc(widget.course.id)
                                    .collection('lessons')
                                    .doc(data[index]
                                        .id) // Ensure this document ID is correct
                                    .snapshots(),
                                builder: (ctx,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.exists) {
                                    // Access the document data directly
                                    var lessonData = snapshot.data!.data()
                                        as Map<String, dynamic>;
                                    if (lessonData['learned']) {
                                      return const Icon(Icons.done_all_sharp,
                                          color: Color.fromARGB(
                                              255, 124, 157, 255));
                                    } else {
                                      return Icon(Icons.done_all_sharp,
                                          color: Theme.of(ctx)
                                              .colorScheme
                                              .onBackground);
                                    }
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (!snapshot.hasData) {
                                    return const Text('No data');
                                  } else {
                                    // Default fallback for waiting state
                                    return const CircularProgressIndicator();
                                  }
                                }));
                      },
                    ),
                  )
                : Text(
                    'About course...',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
          ],
        ),
      ),
    );
  }
}
