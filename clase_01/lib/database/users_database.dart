import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:clase_01/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UsersDatabase {
  static UsersDatabase?
      _usersDatabase; //Singleton Usersdatabase O sea que solo se crea 1 vez

  static Database? _database; //Singleton Database

  //Nombre y Columnas de la tabla
  String usersTable = 'users_table';
  String colId = 'id';
  String colName = 'name';
  String colEmail = 'email';
  String colPassword = 'password';
  String colAvatarPath = 'avatarPath';

  UsersDatabase._createInstance(); //Constructor nombrado para crear instancia de la BD

  factory UsersDatabase() {
    if (_usersDatabase == null) {
      _usersDatabase = UsersDatabase._createInstance(); //Se ejecuta 1 sola vez
    }
    return _usersDatabase!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'users.db';

    debugPrint(path);

    //Open/Create DB
    var usersDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return usersDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''CREATE TABLE $usersTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colName TEXT NOT NULL,
          $colEmail TEXT NOT NULL UNIQUE,
          $colPassword TEXT NOT NULL,
          $colAvatarPath TEXT NOT NULL)''');
  }

  // Encriptar contraseña
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  //Encontrar Usuario por Email
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await this.database;

    final List<Map<String, dynamic>> result = await db.query(
      usersTable,
      where: '$colEmail = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  //Insertar Usuario
  Future<int> insertUser(UserModel user) async {
    final db = await this.database;

    final existingUser = await getUserByEmail(user.email);

    if (existingUser != null) {
      throw Exception('El email ya esta registrado');
    } else {
      final userHashed = UserModel(
        name: user.name,
        email: user.email,
        password: _hashPassword(user.password),
        avatarPath: user.avatarPath,
      );

      final result = await db.insert(usersTable, userHashed.toMap());
      return result;
    }
  }

  //Validar login
  Future<UserModel?> validateLogin(String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);

    final List<Map<String, dynamic>> maps = await db.query(
      usersTable,
      where: '$colEmail = ? AND $colPassword = ?',
      whereArgs: [email, hashedPassword],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }
}
