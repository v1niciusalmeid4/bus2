import 'package:sqflite/sqflite.dart';

import 'package:bus2/core/core.dart';
import '../models/models.dart';

class UserLocalDataSourcePath {
  static const users = 'users';
}

class UserLocalRepository {
  final Database db;

  UserLocalRepository({required this.db});

  static Future<UserLocalRepository> create() async {
    final db = await DatabaseProvider.open();

    return UserLocalRepository(db: db);
  }

  Future<void> saveUsers(List<UserModel> users) async {
    if (users.isEmpty) return;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final u in users) {
        batch.insert(
          UserLocalDataSourcePath.users,
          UserModel.toDatabase(u),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> saveUser(UserModel user) async {
    await db.insert(
      UserLocalDataSourcePath.users,
      UserModel.toDatabase(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeUser(String uuid) async {
    await db.delete(
      UserLocalDataSourcePath.users,
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
  }

  Future<List<UserModel>> getUsers() async {
    final rows = await db.query(UserLocalDataSourcePath.users);

    return rows.map(UserModel.fromDatabase).toList();
  }

  Future<bool> userExistsByUuid(String uuid) async {
    final result = await db.rawQuery(
      'SELECT 1 FROM users WHERE uuid = ? LIMIT 1',
      [uuid],
    );
    return result.isNotEmpty;
  }

  Future<UserModel?> getUserByUuid(String uuid) async {
    final rows = await db.query(
      UserLocalDataSourcePath.users,
      where: 'uuid = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return UserModel.fromDatabase(rows.first);
  }
}
