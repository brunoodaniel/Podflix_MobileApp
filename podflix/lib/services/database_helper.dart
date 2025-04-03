import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "PodflixDB.db";
  static const _databaseVersion = 1;

  // Tabelas e colunas
  static const tableUsers = 'users';
  static const columnUserId = 'id';
  static const columnUserEmail = 'email';
  static const columnUserPassword = 'password';

  static const tableFavorites = 'favorites';
  static const columnFavoriteId = 'id';
  static const columnUserIdFk = 'user_id';
  static const columnPodcastTitle = 'title';
  static const columnPodcastImage = 'image_path';
  static const columnPodcastDesc = 'description';
  static const columnPodcastDate = 'date';

  static const tableMarked = 'marked';
  static const columnMarkedId = 'id';
  static const columnUserIdFkMarked = 'user_id';
  static const columnPodcastTitleMarked = 'title';
  static const columnPodcastImageMarked = 'image_path';
  static const columnPodcastDescMarked = 'description';
  static const columnPodcastDateMarked = 'date';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnUserId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserEmail TEXT NOT NULL UNIQUE,
        $columnUserPassword TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableFavorites (
        $columnFavoriteId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserIdFk INTEGER NOT NULL,
        $columnPodcastTitle TEXT NOT NULL,
        $columnPodcastImage TEXT NOT NULL,
        $columnPodcastDesc TEXT NOT NULL,
        $columnPodcastDate TEXT NOT NULL,
        FOREIGN KEY ($columnUserIdFk) REFERENCES $tableUsers ($columnUserId)
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMarked (
        $columnMarkedId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserIdFkMarked INTEGER NOT NULL,
        $columnPodcastTitleMarked TEXT NOT NULL,
        $columnPodcastImageMarked TEXT NOT NULL,
        $columnPodcastDescMarked TEXT NOT NULL,
        $columnPodcastDateMarked TEXT NOT NULL,
        FOREIGN KEY ($columnUserIdFkMarked) REFERENCES $tableUsers ($columnUserId)
      )
    ''');
  }

  // Métodos para Usuários
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, row);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      tableUsers,
      where: '$columnUserEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Métodos para Favoritos
  Future<int> insertFavorite(int userId, Map<String, dynamic> podcast) async {
    Database db = await instance.database;
    return await db.insert(tableFavorites, {
      columnUserIdFk: userId,
      columnPodcastTitle: podcast['title'],
      columnPodcastImage: podcast['imageUrl'],
      columnPodcastDesc: podcast['description'],
      columnPodcastDate: podcast['date'],
    });
  }

  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    Database db = await instance.database;
    return await db.query(
      tableFavorites,
      where: '$columnUserIdFk = ?',
      whereArgs: [userId],
    );
  }

  Future<int> removeFavorite(int userId, String podcastTitle) async {
    Database db = await instance.database;
    return await db.delete(
      tableFavorites,
      where: '$columnUserIdFk = ? AND $columnPodcastTitle = ?',
      whereArgs: [userId, podcastTitle],
    );
  }

  // Métodos para Marcados
  Future<int> insertMarked(int userId, Map<String, dynamic> podcast) async {
    Database db = await instance.database;
    return await db.insert(tableMarked, {
      columnUserIdFkMarked: userId,
      columnPodcastTitleMarked: podcast['title'],
      columnPodcastImageMarked: podcast['imageUrl'],
      columnPodcastDescMarked: podcast['description'],
      columnPodcastDateMarked: podcast['date'],
    });
  }

  Future<List<Map<String, dynamic>>> getMarked(int userId) async {
    Database db = await instance.database;
    return await db.query(
      tableMarked,
      where: '$columnUserIdFkMarked = ?',
      whereArgs: [userId],
    );
  }

  Future<int> removeMarked(int userId, String podcastTitle) async {
    Database db = await instance.database;
    return await db.delete(
      tableMarked,
      where: '$columnUserIdFkMarked = ? AND $columnPodcastTitleMarked = ?',
      whereArgs: [userId, podcastTitle],
    );
  }
}