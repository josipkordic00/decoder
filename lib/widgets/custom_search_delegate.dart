// import 'package:decoder/models/course.dart';
// import 'package:flutter/material.dart';
// import 'package:decoder/data/dummydata.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CustomSearchDelegate extends SearchDelegate {
//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return theme.copyWith(
//       inputDecorationTheme: const InputDecorationTheme(
//           outlineBorder: BorderSide.none,
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide.none
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide.none
//           ),
          
//           border: OutlineInputBorder(borderSide: BorderSide.none,
        
//           ),),
          
//       textTheme: GoogleFonts.montserratTextTheme(
//         Theme.of(context).textTheme.merge(
//               TextTheme(
//                 titleLarge: TextStyle(
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//             ),
//       ),
//     );
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: Icon(
//           Icons.clear,
//           color: Theme.of(context).colorScheme.onBackground,
//         ),
//       ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null);
//         },
//         icon: Icon(
//           Icons.arrow_back,
//           color: Theme.of(context).colorScheme.onBackground,
//         ));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List<List<dynamic>> matchQuery = [];
//     for (var i in lessons) {
//       if (i.title.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add([
//           i,
//           Icon(
//             Icons.play_circle,
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//           'Lesson'
//         ]);
//       }
//     }
//     for (var i in users) {
//       Course concat = Course(title: '${i.firstName} ${i.lastName}');
//       if (concat.title.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add([
//           concat,
//           Icon(
//             Icons.account_circle,
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//           'User'
//         ]);
//       }
//     }
//     for (var i in courses) {
//       if (i.title.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add([
//           i,
//           Icon(
//             Icons.book,
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//           'Course'
//         ]);
//       }
//     }
//     return ListView.builder(
//         itemCount: matchQuery.length,
//         itemBuilder: (context, index) {
//           var result = matchQuery[index];
//           return ListTile(
//             leading: Icon(
//               Icons.account_circle,
//               color: Theme.of(context).colorScheme.onBackground,
//             ),
//             title: Text(
//               result[0].title,
//               style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   color: Theme.of(context).colorScheme.onBackground,
//                   fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(
//               result[0].title,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodySmall!
//                   .copyWith(color: Theme.of(context).colorScheme.onBackground),
//             ),
//           );
//         });
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<List<dynamic>> matchQuery = [];

//     //making list type of[model, icon, string] for users
//     for (var i in users) {
//       //map users name into course model title for easier applying in search
//       Course concat = Course(title: '${i.firstName} ${i.lastName}');
//       if (concat.title.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add([
//           concat,
//           Icon(
//             Icons.account_circle,
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//           'User'
//         ]);
//       }
//     }

//     //making list type of[model, icon, string] for courses
//     for (var i in courses) {
//       if (i.title.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add([
//           i,
//           Icon(
//             Icons.book,
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//           'Course'
//         ]);
//       }
//     }

//     //making list type of[model, icon, string] for lessons
//     for (var i in lessons) {
//       if (i.title.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add([
//           i,
//           Icon(
//             Icons.play_circle,
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//           'Lesson'
//         ]);
//       }
//     }

//     return Container(
//       decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [
//         Theme.of(context).colorScheme.background,
//         Theme.of(context).appBarTheme.backgroundColor!
//       ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
//       child: ListView.builder(
//           itemCount: matchQuery.length,
//           itemBuilder: (context, index) {
//             //result = current index in list[widget, icon, string]
//             var result = matchQuery[index];
//             return ListTile(
//               leading: result[1],
//               title: Text(
//                 result[0].title,
//                 style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                     color: Theme.of(context).colorScheme.onBackground,
//                     fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(
//                 result[2],
//                 style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                     color: Theme.of(context).colorScheme.onBackground),
//               ),
//             );
//           }),
//     );
//   }
// }
