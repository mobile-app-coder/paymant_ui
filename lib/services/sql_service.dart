import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:paymant_ui/models/credit_card_model.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  static const _dbDame = "card_db.db";
  static const _dbVersion = 1;

  static Database? _database;

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cards (
          id INTEGER PRIMARY KEY,
          cardNumber TEXT NOT NULL,
          expiredDate TEXT NOT NULL,
          cardType TEXT NOT NULL,
          cardImage TEXT NOT NULL )
          ''');
  }

  static _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbDame);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  static Future<void> init() async {
    _database = await _initDatabase();
  }

  static Future<CreditCard> createCard(CreditCard card) async {
    Database db = _database!;
    await db.insert("cards", card.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return card;
  }

  static Future<List<CreditCard>> fetchCards() async {
    Database db = _database!;
    List<Map<String, dynamic>> results = await db.query("cards");

    List<CreditCard> cards = [];

    results.forEach((element) {
      CreditCard card = CreditCard.fromMap(element);
      cards.add(card);
    });
    return cards;
  }

  static Future<CreditCard> fetchCard(int id) async {
    List<Map<String, dynamic>> results =
        await _database!.query('cards', where: 'id = ?', whereArgs: [id]);
    CreditCard card = CreditCard.fromMap(results[0]);
    return card;
  }

  static Future<int> deleteCard(int id) async {
    return await _database!.delete("cards", where: "id = ?", whereArgs: [id]);
  }

  static Future<CreditCard> updatePost(CreditCard card) async {
    Database db = _database!;
    var count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM post WHERE id = ?", [card.id]));
    if (count != 0) {
      await db
          .update("post", card.toMap(), where: "id = ?", whereArgs: [card.id]);
    }
    return card;
  }
}
