import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _dbName = 'app.db';
  static const _dbVersion = 1;

  static Database? _instance;

  static Future<Database> open() async {
    if (_instance != null) return _instance!;

    final dir = await getApplicationDocumentsDirectory();

    final path = p.join(dir.path, _dbName);

    _instance = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _instance!;
  }

  static Future<void> close() async {
    final db = _instance;
    if (db != null && db.isOpen) {
      await db.close();
      _instance = null;
    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE IF NOT EXISTS users (
    uuid                TEXT PRIMARY KEY,   
    gender              TEXT,
    email               TEXT,
    phone               TEXT,
    cell                TEXT,
    nat                 TEXT,
    name_title          TEXT,
    name_first          TEXT,
    name_last           TEXT,
    loc_street_number   INTEGER,
    loc_street_name     TEXT,
    loc_city            TEXT,
    loc_state           TEXT,
    loc_country         TEXT,
    loc_postcode        TEXT,
    loc_coords_lat      TEXT,
    loc_coords_lng      TEXT,
    loc_tz_offset       TEXT,
    loc_tz_desc         TEXT,
    login_username      TEXT,
    login_md5           TEXT,
    login_sha1          TEXT,
    login_sha256        TEXT,
    dob_date            TEXT,
    dob_age             INTEGER,
    reg_date            TEXT,
    reg_age             INTEGER,
    id_name             TEXT,
    id_value            TEXT,
    picture_large       TEXT,
    picture_medium      TEXT,
    picture_thumbnail   TEXT
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS user_pages (
    page  INTEGER NOT NULL,
    uuid  TEXT    NOT NULL,
    PRIMARY KEY (page, uuid) ON CONFLICT REPLACE,
    FOREIGN KEY (uuid) REFERENCES users(uuid) ON DELETE CASCADE
  );
  ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_users_last_first ON users(name_last, name_first);',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_users_country    ON users(loc_country);',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_users_username   ON users(login_username);',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_users_nat        ON users(nat);',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_user_pages_page  ON user_pages(page);',
    );
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Em dev, o mais simples é dropar e recriar:
    await db.execute('DROP TABLE IF EXISTS user_pages;');
    await db.execute('DROP TABLE IF EXISTS users;');
    await _onCreate(db, newVersion);
  }
}
