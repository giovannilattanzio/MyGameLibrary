import 'package:igdb_client/igdb_client.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/models/platform_logo_model.dart';
import 'package:my_game_library/src/models/platform_model.dart';
import 'package:my_game_library/src/repo/repository.dart' show Source;
import 'package:my_game_library/src/utils/igdb/igdb_api.dart';

class IGDBApiProvider implements Source {
  final _client = IGDBClient(
    "Flutter",
    IGDBApi.API,
//    logger: IGDBConsoleLogger(),
  );

  /// Metodo per recuperare uno o più giochi dalla chiamata all'API di IGDB.
  ///
  /// In caso di passaggio di un [id], verrà restituita una lista con al massimo un elemento
  /// In caso di passaggio di una String [query] verrà restituita una lista con tutti i giochi con il nome contenente tale valore
  @override
  Future<List<GameModel>> fetchGames({int id, String query}) async {
    final requestParameters = id != null
        ? IGDBRequestParameters(
            fields: ['*'],
            ids: [id],
          )
        : IGDBRequestParameters(
            fields: ['*'],
            search: query,
          );

    final gamesResponse = await _client.games(requestParameters);

    print(IGDBClient.getPrettyStringFromMap(gamesResponse.toMap()));

    if (gamesResponse.isSuccess()) {
      // do something with gamesResponse.data
      return _gamesListFromResponse(gamesResponse);
    } else {
      // do something depending on gamesResponse.error
      return null;
    }
  }

  /// Metodo per recuperare dei giochi più recenti (entro un mese) dalla chiamata all'API di IGDB.
  ///
  /// In caso di passaggio di una String [query] verrà restituita una lista con tutti i giochi con il nome contenente tale valore
  @override
  Future<List<GameModel>> fetchLatestGames({String query}) async {
    final requestParameters = IGDBRequestParameters(
      fields: ['*'],
      search: query != null ? query : null,
      filters:
          'first_release_date > ${DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day).millisecondsSinceEpoch}',
    );

    final gamesResponse = await _client.games(requestParameters);

    print(IGDBClient.getPrettyStringFromMap(gamesResponse.toMap()));

    if (gamesResponse.isSuccess()) {
      return _gamesListFromResponse(gamesResponse);
    } else {
      return null;
    }
  }

  @override
  Future<List<GameModel>> fetchFavoriteGames({String query}) {
    return null;
  }

  /// Restituisce la lista di piattaforme dall'API di IGDB.
  @override
  Future<List<PlatformModel>> fetchPlatforms() async {
    final requestParameters = IGDBRequestParameters(
      fields: ['*'],
      ids: [
        IGDBPlatforms.PLAYSTATION_4.id,
        IGDBPlatforms.XBOX_ONE.id,
        IGDBPlatforms.NINTENDO_3DS.id,
        IGDBPlatforms.SWITCH.id,
      ],
    );

    final platformsResponse = await _client.platforms(requestParameters);

    if (platformsResponse.isSuccess()) {
      final platformsList = platformsResponse.data
          .map((platform) => PlatformModel.fromJson(platform));

      return platformsList?.toList();
    } else {
      return null;
    }
  }

  /// Restituisce l'oggetto che mappa il logo di una piattaforma dall'API di IGDB.
  @override
  Future<PlatformLogoModel> fetchPlatformLogo(int id) async {
    final requestParameters = IGDBRequestParameters(
      fields: ['*'],
      ids: [id],
    );

    final platformLogoResponse =
        await _client.requestByPath("platform_logos", requestParameters);

    if (platformLogoResponse.isSuccess()) {
      final platformLogoList = platformLogoResponse.data
          .map((platformLogo) => PlatformLogoModel.fromJson(platformLogo));

      return platformLogoList?.toList()?.first;
    } else {
      return null;
    }
  }

  /// Metodo per resistuire un [List] di [GameModel] partendo dalla [response] di tipo [IGDBResponse]
  List<GameModel> _gamesListFromResponse(IGDBResponse response) {
    final gamesList = response.data.map((game) => GameModel.fromJson(game));

    return gamesList?.toList();
  }
}
