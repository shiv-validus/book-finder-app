import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'package:book_finder_app/core/widgets/feature_card.dart';
import 'package:book_finder_app/core/widgets/animations/animated_feature_card.dart';

import 'package:book_finder_app/features/book_finder/data/datasources/book_remote_data_source.dart';
import 'package:book_finder_app/features/book_finder/data/repositories/book_repository_impl.dart';
import 'package:book_finder_app/features/book_finder/domain/usecases/search_books.dart';
import 'package:book_finder_app/features/book_finder/presentation/bloc/search_book_bloc.dart';
import 'package:book_finder_app/features/book_finder/presentation/pages/search_screen.dart';

import 'package:book_finder_app/features/sensor/cubit/sensor_cubit.dart';
import 'package:book_finder_app/features/sensor/presentation/sensor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                        colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  child: const Text(
                    '🚀 Choose a Feature',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // required but will be masked
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        AnimatedFeatureCard(
                          delay: const Duration(milliseconds: 300),
                          child: Hero(
                            tag: 'Book Finder',
                            child: FeatureCard(
                              emoji: "📚",
                              title: "Book Finder",
                              description:
                                  "Search and explore books using OpenLibrary",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) => SearchBookBloc(
                                        searchBooks: SearchBooks(
                                          BookRepositoryImpl(
                                            remoteDataSource:
                                                BookRemoteDataSourceImpl(
                                                  dio: Dio(),
                                                ),
                                          ),
                                        ),
                                      ),
                                      child: const SearchScreen(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AnimatedFeatureCard(
                          delay: const Duration(milliseconds: 500),
                          child: FeatureCard(
                            emoji: "🔦",
                            title: "Sensor Info",
                            description:
                                "Toggle flashlight and test device sensors",
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
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
