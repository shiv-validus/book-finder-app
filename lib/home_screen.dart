// home_screen.dart
import 'package:book_finder_app/features/book_finder/data/datasources/book_remote_data_source.dart';
import 'package:book_finder_app/features/book_finder/data/repositories/book_repository_impl.dart';
import 'package:book_finder_app/features/book_finder/domain/usecases/search_books.dart';
import 'package:book_finder_app/features/book_finder/presentation/bloc/search_book_bloc.dart';
import 'package:book_finder_app/features/book_finder/presentation/pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../features/sensor/presentation/sensor_screen.dart';
import '../features/sensor/cubit/sensor_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3F3),
      appBar: AppBar(
        title: const Text('📱 Choose a Feature'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FeatureCard(
              title: "📚 Book Finder",
              description: "Search and explore books using OpenLibrary",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => SearchBookBloc(
                        searchBooks: SearchBooks(
                          BookRepositoryImpl(
                            remoteDataSource: BookRemoteDataSourceImpl(dio: Dio()),
                          ),
                        ),
                      ),
                      child: const SearchScreen(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            FeatureCard(
              title: "🔦 Sensor Info",
              description: "Toggle flashlight and test device sensors",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => SensorCubit(),
                      child: const SensorScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: Colors.deepPurple.withOpacity(0.1),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 8),
              Text(description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
