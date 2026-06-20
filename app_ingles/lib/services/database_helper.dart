import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/category.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "LearningApp.db");

    // Always copy the database from assets to path on startup to ensure updates are applied
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data = await rootBundle.load("assets/LearningApp.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    return await openDatabase(path, readOnly: true);
  }


  Future<List<LearnPhraseCategory>> getPhraseCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tblPhraseCategory');
    return maps.map((m) => LearnPhraseCategory.fromMap(m)).toList();
  }

  Future<List<LearnCategory>> getWordCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tblLearnCategory');
    return maps.map((m) => LearnCategory.fromMap(m)).toList();
  }


  Future<List<LearnWord>> getWordsByCategoryId(int categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblLearnWords',
      where: 'CategoryId = ?',
      whereArgs: [categoryId],
    );
    return maps.map((m) => LearnWord.fromMap(m)).toList();
  }

  Future<List<LearnPhrase>> getPhrasesByCategoryId(int categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tblPhrases',
      where: 'CategoryId = ?',
      whereArgs: [categoryId],
    );
    return maps.map((m) => LearnPhrase.fromMap(m)).toList();
  }

  Future<List<LearnSentence>> getSentences() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tblSentence');
    return maps.map((m) => LearnSentence.fromMap(m)).toList();
  }
}
