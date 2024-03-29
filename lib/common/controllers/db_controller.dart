import 'package:e_fashion/user/models/user_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
  // DatabaseController.ensureInitialized();

  // Open the database and store the reference.
  Future<Database> init() async {
    return openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) => {
        db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT, password TEXT, address TEXT, city TEXT, state TEXT, postalcode TEXT, phone TEXT)',
        ),
      },
      version: 1,
    );
  }

  // inserts users into the database
  // replace any previous data.
  Future<void> insertUser(UserClass user) async {
    final db = await init();

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // update user
  Future<void> updateUser(UserClass user) async {
    final db = await init();

    // Update the given user.
    await db.update(
      'users',
      user.toMap(),
      // Ensure that the User has a matching id.
      where: 'id = ?',
      // Pass the user's id as a whereArg to prevent SQL injection.
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await init();

    // Remove the User from the database.
    await db.delete(
      'users',
      // Use a `where` clause to delete a specific user.
      where: 'id = ?',
      // Pass the User's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  //retrieves all the users from the users table.
  Future<UserClass> users() async {
    final db = await init();

    // Query the table for all the users.
    final List<Map<String, Object?>> userMaps = await db.query('users');
    if (userMaps.isEmpty) {
      return const UserClass(id: -1, email: '', password: '', address: '', city: '', state: '', postalcode: '', phone: '');
    }
    print(userMaps.toString());
    return UserClass(
        id: userMaps.elementAt(0)['id'] as int,
        email: userMaps.elementAt(0)['email'] as String,
        password: userMaps.elementAt(0)['password'] as String,
        address: userMaps.elementAt(0)['address'] as String,
        city: userMaps.elementAt(0)['city'] as String,
        state: userMaps.elementAt(0)['state'] as String,
        postalcode: userMaps.elementAt(0)['postalcode'] as String,
        phone: userMaps.elementAt(0)['phone'] as String,
        );
  }
}
