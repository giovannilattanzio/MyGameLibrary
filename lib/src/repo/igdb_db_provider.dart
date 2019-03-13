import 'package:my_game_library/src/models/game_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:my_game_library/src/repo/repository.dart' show Source, Cache;
import 'package:my_game_library/src/utils/igdb/igdb_game_fields.dart';
import 'package:my_game_library/src/utils/sqflite/db_personal_game_fields.dart';

class IGDBDbProvider implements Source, Cache {
  final String _gamesTableName = "games";

  static final IGDBDbProvider _instance = IGDBDbProvider._internal();

  factory IGDBDbProvider() => _instance;

  IGDBDbProvider._internal();

  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await _init();
    }

    return _db;
  }

  Future<Database> _init() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "maindb.db");

    var ourDb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDb,
    );

    return ourDb;
  }

  void _onCreateDb(Database db, int version) {
    db.execute("""
      CREATE TABLE $_gamesTableName
        (
          ${IGDBGameFields.id} INTEGER PRIMARY KEY,
          ${IGDBGameFields.aggregated_rating} REAL,
          ${IGDBGameFields.artworks} BLOB,
          ${IGDBGameFields.category} INTEGER,
          ${IGDBGameFields.cover} INTEGER,
          ${IGDBGameFields.genres} BLOB,
          ${IGDBGameFields.name} STRING,
          ${IGDBGameFields.platforms} BLOB,
          ${IGDBGameFields.popularity} REAL,
          ${IGDBGameFields.rating} REAL,
          ${IGDBGameFields.screenshots} BLOB,
          ${IGDBGameFields.similar_games} BLOB,
          ${IGDBGameFields.slug} STRING,
          ${IGDBGameFields.storyline} STRING,
          ${IGDBGameFields.summary} STRING,
          ${IGDBGameFields.themes} BLOB,
          ${IGDBGameFields.total_rating} REAL,
          ${IGDBGameFields.videos} BLOB,
          ${IGDBGameFields.websites} BLOB,
          ${DBPersonalGameFields.favorite} INTEGER
        )
    """);
  }

  /// Metodo per recuperare uno o più giochi dal database interno.
  ///
  /// In caso di passaggio di un [id], verrà restituita una lista con al massimo un elemento
  /// In caso di passaggio di una String [query] verrà restituita una lista con tutti i giochi con il nome contenente tale valore
  @override
  Future<List<GameModel>> fetchGames({int id, String query}) async {
    var dbInstance = await db;

    final map = await dbInstance.query(
      _gamesTableName,
      columns: null,
      where: id != null ? "${IGDBGameFields.id} = ?" : "name LIKE ?",
      whereArgs: id != null ? [id] : ['%$query%'],
    );

    if (map.length > 0) {
      final list = map.map((game) => GameModel.fromDB(game));

      return list?.toList();
    }

    return null;
  }

  /// Restituisce tutti gli ultimi videogames in ordine di uscita
  @override
  Future<List<GameModel>> fetchLatestGames({String query}) {
    return null;
  }

  /// Restituisce tutti i giochi salvati come preferiti
  @override
  Future<List<GameModel>> fetchFavoriteGames({String query}) async {
    var dbInstance = await db;

    String where = "${DBPersonalGameFields.favorite} = ?";
    if (query != null && query.isNotEmpty) {
      where += "AND name LIKE ?";
    }

    final map = await dbInstance.query(
      _gamesTableName,
      columns: null,
      where: where,
      whereArgs: query != null && query.isNotEmpty ? [1, query] : [1],
    );

    if (map.length > 0) {
      final list = map.map((game) => GameModel.fromDB(game));

      return list?.toList();
    }

    return [];
  }

  /// Metodo per gestire il salvataggio di un singolo gioco nel db interno
  ///
  /// In caso di conflitti ([id] già presente) il record verrà sovrascritto
  @override
  Future<int> saveGame(GameModel game) {
    return db.then((database) {
      database.insert(
        _gamesTableName,
        game.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// Metodo per gestire il salvataggio massivo di una lista di giochi nel db interno
  ///
  /// In caso di conflitti ([id] già presente) il record verrà sovrascritto
  @override
  Future<int> saveGames(List<GameModel> games) {
    return db.then((database) {
      var batch = database.batch();
      games.forEach((game) {
        batch.insert(
          _gamesTableName,
          game.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
      batch.commit(noResult: true);
    });
  }

  /// Metodo per cancellare i dati inseriti all'interno del database interno
  @override
  Future<int> clear() {
    return db.then((database) {
      database.delete(_gamesTableName);
    });
  }
}
