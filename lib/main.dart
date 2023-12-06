import 'package:flutter/material.dart';
import 'package:movie_night/screens/EnterScreen.dart';
import 'package:movie_night/screens/MovieScreen.dart';
import 'package:movie_night/screens/ShareScreen.dart';
import 'package:movie_night/screens/WelcomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/welcome':(context) => const WelcomeScreen(),
        '/entercode': (context) => const EnterScreen(),
        '/sharecode': (context) => const ShareScreen(),
        '/movies' : (context) => const MovieScreen()
      },
    );
  }
}
