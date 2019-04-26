import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/models/game_cover_model.dart';
import 'package:my_game_library/src/models/platform_logo_model.dart';
import 'package:my_game_library/src/models/platform_model.dart';
import 'package:my_game_library/src/repo/repository.dart' show Source, Cache;
import 'package:my_game_library/src/utils/igdb/igdb_games.dart';
import 'package:my_game_library/src/utils/igdb/igdb_platforms.dart';
import 'package:my_game_library/src/utils/sqflite/db_personal_game_fields.dart';

class IGDBDbProvider implements Source, Cache {
  final String _gamesTableName = "games";
  final String _gameCoverTableName = "game_cover";
  final String _platformsTableName = "platforms";
  final String _platformLogoTableName = "platform_logo";

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

    db.execute("""
      CREATE TABLE $_gameCoverTableName
        (
          ${IGDBGameCoverFields.id} INTEGER PRIMARY KEY,
          ${IGDBGameCoverFields.alpha_channel} INTEGER,
          ${IGDBGameCoverFields.animated} INTEGER,
          ${IGDBGameCoverFields.game} INTEGER,
          ${IGDBGameCoverFields.height} INTEGER,
          ${IGDBGameCoverFields.image_id} STRING,
          ${IGDBGameCoverFields.url} STRING,
          ${IGDBGameCoverFields.width} INTEGER
        )
    """);

    db.execute("""
      CREATE TABLE $_platformsTableName
        (
          ${IGDBPlatformFields.id} INTEGER PRIMARY KEY,
          ${IGDBPlatformFields.abbreviation} STRING,
          ${IGDBPlatformFields.alternative_name} STRING,
          ${IGDBPlatformFields.category} INTEGER,
          ${IGDBPlatformFields.created_at} INTEGER,
          ${IGDBPlatformFields.generation} INTEGER,
          ${IGDBPlatformFields.name} STRING,
          ${IGDBPlatformFields.platform_logo} INTEGER,
          ${IGDBPlatformFields.product_family} INTEGER,
          ${IGDBPlatformFields.slug} STRING,
          ${IGDBPlatformFields.summary} STRING,
          ${IGDBPlatformFields.updated_at} INTEGER,
          ${IGDBPlatformFields.url} STRING,
          ${IGDBPlatformFields.versions} BLOB,
          ${IGDBPlatformFields.websites} BLOB,
          ${DBPersonalGameFields.order_number} INTEGER
        )
    """);

    db.execute("""
      CREATE TABLE $_platformLogoTableName
        (
          ${IGDBPlatformLogoFields.id} INTEGER PRIMARY KEY,
          ${IGDBPlatformLogoFields.alpha_channel} INTEGER,
          ${IGDBPlatformLogoFields.animated} INTEGER,
          ${IGDBPlatformLogoFields.height} INTEGER,
          ${IGDBPlatformLogoFields.image_id} STRING,
          ${IGDBPlatformLogoFields.url} STRING,
          ${IGDBPlatformLogoFields.width} INTEGER
        )
    """);
  }

  /// Metodo per recuperare uno o più giochi dal database interno.
  ///
  /// In caso di passaggio di un [id], verrà restituita una lista con al massimo un elemento
  /// In caso di passaggio di una String [query] verrà restituita una lista con tutti i giochi con il nome contenente tale valore
  @override
  Future<List<GameModel>> fetchGames(
      {int id, String filters, String query}) async {
    var dbInstance = await db;

    final map = await dbInstance.query(
      _gamesTableName,
      columns: null,
      where: id != null
          ? "${IGDBGameFields.id} = ?"
          : "${IGDBGameFields.name} LIKE ?",
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
      where += "AND ${IGDBGameFields.name} LIKE ?";
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

  /// Restituisce l'oggetto che mappa la cover di un gioco
  @override
  Future<GameCoverModel> fetchGameCover(int id) async {
    var dbInstance = await db;

    final map = await dbInstance.query(
      _gameCoverTableName,
      columns: null,
      where: "${IGDBGameCoverFields.id} = ?",
      whereArgs: [id],
    );

    if (map.length > 0) {
      final list = map.map((gameCover) {
        return GameCoverModel.fromDB(gameCover);
      });

      return list?.toList()?.first;
    }

    return null;
  }

  /// Restituisce la lista di piattaforme salvate sul database interno
  @override
  Future<List<PlatformModel>> fetchPlatforms() async {
    var dbInstance = await db;

    final map = await dbInstance.query(_platformsTableName,
        columns: null, orderBy: "${DBPersonalGameFields.order_number} ASC");

    if (map.length > 0) {
      final list = map.map((platform) {
        return PlatformModel.fromDB(platform);
      });

      return list?.toList();
    }

    return null;
  }

  /// Restituisce l'oggetto che mappa il logo di una piattaforma
  @override
  Future<PlatformLogoModel> fetchPlatformLogo(int id) async {
    var dbInstance = await db;

    final map = await dbInstance.query(
      _platformLogoTableName,
      columns: null,
      where: "${IGDBPlatformLogoFields.id} = ?",
      whereArgs: [id],
    );

    if (map.length > 0) {
      final list = map.map((platformLogo) {
        return PlatformLogoModel.fromDB(platformLogo);
      });

      return list?.toList()?.first;
    }

    return null;
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

  /// Metodo per gestire il salvataggio di una cover di un gioco
  ///
  /// In caso di conflitti ([id] già presente) il record verrà sovrascritto
  @override
  Future<int> saveGameCover(GameCoverModel gameCover) {
    return db.then((database) {
      database.insert(
        _gameCoverTableName,
        gameCover.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// Metodo per gestire il salvataggio massivo di una lista di piattaforme nel db interno
  ///
  /// In caso di conflitti ([id] già presente) il record verrà sovrascritto
  @override
  Future<int> savePlatforms(List<PlatformModel> platforms) {
    return db.then((database) {
      var batch = database.batch();
      var orderToSave = 100;
      platforms.forEach((platform) {
        platform.orderNumber = orderToSave;

        batch.insert(
          _platformsTableName,
          platform.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        orderToSave += 100;
      });
      batch.commit(noResult: true);
    });
  }

  /// Metodo per gestire il salvataggio di un logo di una piattaforma
  ///
  /// In caso di conflitti ([id] già presente) il record verrà sovrascritto
  @override
  Future<int> savePlatformLogo(PlatformLogoModel platformLogo) {
    return db.then((database) {
      database.insert(
        _platformLogoTableName,
        platformLogo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
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
