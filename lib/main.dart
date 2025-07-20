import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const BookFinderApp());
}

class BookFinderApp extends StatelessWidget {
  const BookFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '📚 Book Finder & 🔦 Sensor App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFFAF3F3),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
