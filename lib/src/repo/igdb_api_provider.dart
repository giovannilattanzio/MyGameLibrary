import 'package:igdb_client/igdb_client.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/repo/repository.dart' show Source;
import 'package:my_game_library/src/utils/igdb/igdb_api.dart';

class IGDBApiProvider implements Source {
  final _client = IGDBClient("", IGDBApi.API);

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
    }
    else {
      // do something depending on gamesResponse.error
      return null;
    }
  }

  @override
  Future<List<GameModel>> fetchLatestGames({String query}) async {
    final requestParameters = IGDBRequestParameters(
      fields: ['*'],
      search: query != null ? query : null,
      filters: 'first_release_date > ${DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day).millisecondsSinceEpoch}',
    );

    final gamesResponse = await _client.games(requestParameters);

    print(IGDBClient.getPrettyStringFromMap(gamesResponse.toMap()));

    if (gamesResponse.isSuccess()) {
      return _gamesListFromResponse(gamesResponse);
    }
    else {
      return null;
    }

  }

  @override
  Future<List<GameModel>> fetchFavoriteGames({String query}) {
    return null;
  }

  /// Metodo per resistuire un [List] di [GameModel] partendo dalla [response] di tipo [IGDBResponse]
  List<GameModel> _gamesListFromResponse(IGDBResponse response) {

    final gamesList = response.data.map((game) =>
        GameModel.fromJson(game));

    return gamesList?.toList();
  }
}
