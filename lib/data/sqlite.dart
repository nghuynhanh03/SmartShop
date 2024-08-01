// ignore_for_file: avoid_print

import 'package:flutter_application_smartshop/model/favorite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/cart.dart';

class DatabaseHelper {
  // Singleton pattern
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
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'db_cart.db');
    print("Database path: $path");
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Cart('
      'productID INTEGER PRIMARY KEY, name TEXT, price REAL, img TEXT, des TEXT, count INTEGER)',
    );
    await db.execute(
      'CREATE TABLE Favorite('
      'productID INTEGER PRIMARY KEY, name TEXT, price REAL, img TEXT, des TEXT, count INTEGER)',
    );
  }

  Future<void> insertProduct(Cart productModel) async {
    final db = await database;
    await db.insert(
      'Cart',
      productModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cart>> products() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Cart');
    return List.generate(maps.length, (index) => Cart.fromMap(maps[index]));
  }

  Future<Cart?> product(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Cart', where: 'productID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Cart.fromMap(maps[0]);
    }
    return null;
  }

  Future<void> minus(Cart product) async {
    final db = await database;
    if (product.count >= 1) product.count--;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> add(Cart product) async {
    final db = await database;
    product.count++;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> deleteProduct(Cart product) async {
    final db = await database;
    await db.delete(
      'Cart',
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> clear() async {
    final db = await database;
    await db.delete('Cart', where: 'count > 0');
  }

  Future<void> addFavorite(Favorite product) async {
    final db = await database;
    await db.insert(
      'Favorite',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete(
      'Favorite',
      where: 'productID = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(int productId) async {
    final db = await database; // Your database instance
    final result = await db.query(
      'Favorite',
      where: 'productID = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }

  Future<List<Favorite>> getFavorite() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Favorite');
    return List.generate(maps.length, (index) => Favorite.fromMap(maps[index]));
  }
}
