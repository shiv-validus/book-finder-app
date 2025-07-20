import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/book.dart';
import 'package:flutter/foundation.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._internal();
  static Database? _database;

  LocalDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    debugPrint('📂 DB Path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            coverId INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertBook(Book book) async {
    final db = await instance.database;
    await db.insert('books', {
      'title': book.title,
      'author': book.authorName.join(', '),
      'coverId': book.coverId,
    });
    debugPrint('✅ Book saved: ${book.title}');
  }

  Future<List<Book>> getAllBooks() async {
    final db = await instance.database;
    final maps = await db.query('books');
    return maps.map((map) => Book(
      title: map['title'] as String,
      authorName: (map['author'] as String).split(', '),
      coverId: map['coverId'] as int?,
    )).toList();
  }

  Future<void> deleteAllBooks() async {
    final db = await instance.database;
    await db.delete('books');
  }
}
