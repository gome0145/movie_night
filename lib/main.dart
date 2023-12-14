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
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color.fromARGB(255, 12, 16, 58),
          onPrimary: Colors.black,
          secondary: Colors.yellow.shade200,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.red.shade900,
          background: Colors.white,
          onBackground: Colors.black87,
          surface: Colors.purple.shade100,
          onSurface: Colors.purple.shade900,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 57, color: Colors.white, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 45, color: Colors.white),
          displaySmall: TextStyle(fontSize: 36, color: Colors.white),
          headlineLarge: TextStyle(fontSize: 32, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 28, color: Colors.white),
          headlineSmall: TextStyle(fontSize: 24, color: Colors.white),
          titleLarge: TextStyle(fontSize: 22, color: Colors.white),
          titleMedium: TextStyle(fontSize: 16, color: Colors.white),
          titleSmall: TextStyle(fontSize: 14, color: Colors.indigo),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
          labelLarge: TextStyle(fontSize: 14, color: Colors.white),
          labelMedium: TextStyle(fontSize: 12),
          labelSmall: TextStyle(fontSize: 11),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/entercode': (context) => const EnterScreen(),
        '/sharecode': (context) => const ShareScreen(),
        '/movies': (context) => const MovieScreen(),
      },
    );
  }
}
