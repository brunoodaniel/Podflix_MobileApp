import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Configurações do banco de dados
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

  // Padrão Singleton para ter apenas uma instância do banco de dados
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  _initDatabase() async {
    // Obtém o diretório de documentos do aplicativo
    final documentsDirectory = await getApplicationDocumentsDirectory();
    // Define o caminho do banco de dados
    final path = join(documentsDirectory.path, _databaseName);
    // Abre o banco de dados
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,  // Executa a criação das tabelas quando o BD é criado
    );
  }

  // Cria as tabelas quando o banco de dados é criado
  Future _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnUserId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserEmail TEXT NOT NULL UNIQUE,
        $columnUserPassword TEXT NOT NULL
      )
    ''');

    // Tabela de favoritos
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

    // Tabela de marcados
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

  // --- CRUD para Usuários ---

  // Create - Insere um novo usuário
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, row);
  }

  // Read - Obtém um usuário por email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      tableUsers,
      where: '$columnUserEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Atualiza os dados de um usuário
  Future<int> updateUser(int userId, Map<String, dynamic> newData) async {
    Database db = await instance.database;
    return await db.update(
      tableUsers,
      newData,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
  }

  // Delete - Remove um usuário e seus dados relacionados
  Future<int> deleteUser(int userId) async {
    Database db = await instance.database;
    
    // Primeiro deleta os favoritos e marcados do usuário
    await db.delete(
      tableFavorites,
      where: '$columnUserIdFk = ?',
      whereArgs: [userId],
    );
    
    await db.delete(
      tableMarked,
      where: '$columnUserIdFkMarked = ?',
      whereArgs: [userId],
    );
    
    // Depois deleta o usuário
    return await db.delete(
      tableUsers,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
  }

  // --- CRUD para Favoritos ---

  // Create - Adiciona um podcast aos favoritos
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

  // Read - Obtém todos os favoritos de um usuário
  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    Database db = await instance.database;
    return await db.query(
      tableFavorites,
      where: '$columnUserIdFk = ?',
      whereArgs: [userId],
    );
  }

  
  // Delete - Remove um podcast dos favoritos
  Future<int> removeFavorite(int userId, String podcastTitle) async {
    Database db = await instance.database;
    return await db.delete(
      tableFavorites,
      where: '$columnUserIdFk = ? AND $columnPodcastTitle = ?',
      whereArgs: [userId, podcastTitle],
    );
  }

  // --- CRUD para Marcados ---

  // Create - Adiciona um podcast à lista de marcados
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


  // Read - Obtém todos os podcasts marcados de um usuário
  Future<List<Map<String, dynamic>>> getMarked(int userId) async {
    Database db = await instance.database;
    return await db.query(
      tableMarked,
      where: '$columnUserIdFkMarked = ?',
      whereArgs: [userId],
    );
  }

  

  // Delete - Remove um podcast da lista de marcados
  Future<int> removeMarked(int userId, String podcastTitle) async {
    Database db = await instance.database;
    return await db.delete(
      tableMarked,
      where: '$columnUserIdFkMarked = ? AND $columnPodcastTitleMarked = ?',
      whereArgs: [userId, podcastTitle],
    );
  }
}