import 'package:decoder/screens/auth.dart';
import 'package:decoder/screens/home.dart';
import 'package:decoder/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 21, 0, 103),
);
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 66, 123),
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decoder',
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme.copyWith(
            tertiary: const Color.fromARGB(255, 0, 64, 0),
            onTertiary: Colors.white),
        textTheme: GoogleFonts.montserratTextTheme(),
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(
              255, 20, 20, 20), // Set the background color of the app bar
          foregroundColor: Colors.white,

          // Set the color of the content within the app bar (e.g., icons, text)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(kDarkColorScheme.onSecondary),
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(
              255, 236, 240, 250), // Set the background color of the app bar
          foregroundColor: Colors
              .black, // Set the color of the content within the app bar (e.g., icons, text)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(kColorScheme.primaryContainer),
          ),
        ),
        colorScheme: kColorScheme.copyWith(
            tertiary: const Color.fromARGB(255, 0, 166, 0),
            onTertiary: Colors.white),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const AuthScreen();
          }),
    );
  }
}
