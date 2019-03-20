import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/models/game_cover_model.dart';
import 'package:my_game_library/src/models/platform_model.dart';
import 'package:my_game_library/src/models/platform_logo_model.dart';
import 'package:my_game_library/src/repo/igdb_api_provider.dart';
import 'package:my_game_library/src/repo/igdb_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    IGDBDbProvider(),
    IGDBApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    IGDBDbProvider(),
  ];

  /// Metodo per recuperare uno o più giochi, cercandoli prima nei componenti della lista [sources].
  ///
  /// In caso di passaggio di un [id], verrà restituita una lista con al massimo un elemento
  /// In caso di passaggio di una String [query] verrà restituita una lista con tutti i giochi con il nome contenente tale valore
  Future<List<GameModel>> fetchGames({int id, String query}) async {
    List<GameModel> gamesList;
    var source;

    ///potevo lasciarlo nel for, ma l'ho portato fuori e reso [var] (al posto di [final])
    ///per evitare il messaggio di conflitto in [cache != source]

    for (source in sources) {
      gamesList = await source.fetchGames(id: id, query: query);
      if (gamesList != null) {
        for (final cache in caches) {
          if (cache != source) {
            cache.saveGames(gamesList);
          }
        }
        break;
      }
    }

    return gamesList;
  }

  /// Recupera tutti gli ultimi giochi in base alla data di pubblicazione
  Future<List<GameModel>> fetchLatestGames({String query}) async {
    List<GameModel> gamesList;
    var source;

    for (source in sources) {
      gamesList = await source.fetchLatestGames(query: query);
      if (gamesList != null) {
        for (final cache in caches) {
          if (cache != source) {
            cache.saveGames(gamesList);
          }
        }
        break;
      }
    }

    return gamesList;
  }

  /// Restituisce tutti i giochi salvati come preferiti
  Future<List<GameModel>> fetchFavoriteGames({String query}) async {
    List<GameModel> gamesList;
    var source;

    for (source in sources) {
      gamesList = await source.fetchFavoriteGames(query: query);
      if (gamesList != null) {
        for (final cache in caches) {
          if (cache != source) {
            cache.saveGames(gamesList);
          }
        }
        break;
      }
    }

    return gamesList;
  }

  /// Restituisce l'oggetto che mappa la cover di un gioco
  Future<GameCoverModel> fetchGameCover(int id) async {
    GameCoverModel gameCover;
    var source;

    if (id != null) {
      for (source in sources) {
        gameCover = await source.fetchGameCover(id);
        if (gameCover != null) {
          for (final cache in caches) {
            if (cache != source) {
              cache.saveGameCover(gameCover);
            }
          }
          break;
        }
      }
    }

    return gameCover;
  }

  /// Restituisce tutte le piattaforme
  Future<List<PlatformModel>> fetchPlatforms() async {
    List<PlatformModel> platformsList;
    var source;

    for (source in sources) {
      platformsList = await source.fetchPlatforms();
      if (platformsList != null) {
        for (final cache in caches) {
          if (cache != source) {
            cache.savePlatforms(platformsList);
          }
        }
        break;
      }
    }

    return platformsList;
  }

  /// Restituisce l'oggetto che mappa il logo di una piattaforma
  Future<PlatformLogoModel> fetchPlatformLogo(int id) async {
    PlatformLogoModel platformLogo;
    var source;

    if (id != null) {
      for (source in sources) {
        platformLogo = await source.fetchPlatformLogo(id);
        if (platformLogo != null) {
          for (final cache in caches) {
            if (cache != source) {
              cache.savePlatformLogo(platformLogo);
            }
          }
          break;
        }
      }
    }

    return platformLogo;
  }

  /// Metodo per cancellare tutte le cache
  Future<Null> clearCache() async {
    for (final cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<GameModel>> fetchGames({int id, String query});

  Future<List<GameModel>> fetchLatestGames({String query});

  Future<List<GameModel>> fetchFavoriteGames({String query});

  Future<GameCoverModel> fetchGameCover(int id);

  Future<List<PlatformModel>> fetchPlatforms();

  Future<PlatformLogoModel> fetchPlatformLogo(int id);
}

abstract class Cache {
  Future<int> saveGame(GameModel game);

  Future<int> saveGames(List<GameModel> games);

  Future<int> saveGameCover(GameCoverModel gameCover);

  Future<int> savePlatformLogo(PlatformLogoModel platformLogo);

  Future<int> savePlatforms(List<PlatformModel> platforms);

  Future<int> clear();
}
