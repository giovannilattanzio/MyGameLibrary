import 'package:rxdart/rxdart.dart';
import 'package:my_game_library/src/blocs/bloc_provider.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/models/game_cover_model.dart';
import 'package:my_game_library/src/models/platform_model.dart';
import 'package:my_game_library/src/models/platform_logo_model.dart';
import 'package:my_game_library/src/repo/repository.dart';

export 'bloc_provider.dart';

class GamesBloc implements BlocBase {
  final _repository = Repository();
  final _gamesFetcherSubject = BehaviorSubject<String>();
  final _gamesOutputSubject =
      BehaviorSubject<Map<String, Future<List<GameModel>>>>();
  final _gameCoverFetcherSubject = PublishSubject<int>();
  final _gameCoverOutputSubject =
      BehaviorSubject<Map<int, Future<GameCoverModel>>>();
  final _favouriteGamesSubject = BehaviorSubject<List<GameModel>>();

//  final _indexAppBarSubject = BehaviorSubject<int>.seeded(0);
//  final _isListLoadingSubject = BehaviorSubject<Map<String, bool>>();
  final _platformSubject = BehaviorSubject<List<PlatformModel>>();
  final _platformLogoFetcherSubject = PublishSubject<int>();
  final _platformLogoOutputSubject =
      BehaviorSubject<Map<int, Future<PlatformLogoModel>>>();

  Observable<Map<String, Future<List<GameModel>>>> get games =>
      _gamesOutputSubject.stream;

  Observable<Map<int, Future<GameCoverModel>>> get gameCover =>
      _gameCoverOutputSubject.stream;

  Observable<List<GameModel>> get favouriteGames => _favouriteGamesSubject.stream;

//  Observable<int> get indexAppBar => _indexAppBarSubject.stream;
//  Observable<Map<String, bool>> get isListLoading =>
//      _isListLoadingSubject.stream;

  Observable<List<PlatformModel>> get platforms => _platformSubject.stream;

  Observable<Map<int, Future<PlatformLogoModel>>> get platformLogo =>
      _platformLogoOutputSubject.stream;

  GamesBloc() {
    _gamesFetcherSubject.stream
        .transform(_gamesTransformer())
        .pipe(_gamesOutputSubject);

    _gameCoverFetcherSubject.stream
        .transform(_gameCoverTransformer())
        .pipe(_gameCoverOutputSubject);

    _platformLogoFetcherSubject.stream
        .transform(_platformLogoTransformer())
        .pipe(_platformLogoOutputSubject);
  }

  void fetchGames(String filters) {
//    _isListLoadingSubject.add({filters: true});
    _gamesFetcherSubject.sink.add(filters);
  }

  void fetchGameCover(int id) {
    _gameCoverFetcherSubject.sink.add(id);
  }

//  void changeIndexAppBar(int index) {
//    _indexAppBarSubject.sink.add(index);
//  }

  void fetchPlatforms() async {
    final platforms = await _repository.fetchPlatforms();
    _platformSubject.sink.add(platforms);
  }

  void fetchPlatformLogo(int id) {
    _platformLogoFetcherSubject.sink.add(id);
  }

  void fetchFavouriteGames({String query}) async {
    final favouriteGames = await _repository.fetchFavoriteGames(query: query);
    _favouriteGamesSubject.sink.add(favouriteGames);
  }

  @override
  void dispose() {
    _gamesFetcherSubject.close();
    _gamesOutputSubject.close();
    _gameCoverFetcherSubject.close();
    _gameCoverOutputSubject.close();
    _favouriteGamesSubject.close();
//    _indexAppBarSubject.close();
//    _isListLoadingSubject.close();
    _platformSubject.close();
    _platformLogoFetcherSubject.close();
    _platformLogoOutputSubject.close();
  }

  ScanStreamTransformer<String, Map<String, Future<List<GameModel>>>>
      _gamesTransformer() {
    return ScanStreamTransformer<String, Map<String, Future<List<GameModel>>>>(
      (Map<String, Future<List<GameModel>>> cache, String string, _) {
        cache[string] = _repository.fetchGames(filters: string);
//        _isListLoadingSubject.add({string: false});

        return cache;
      },
      <String, Future<List<GameModel>>>{},
    );
  }

  ScanStreamTransformer<int, Map<int, Future<GameCoverModel>>>
      _gameCoverTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<GameCoverModel>>>(
      (Map<int, Future<GameCoverModel>> cache, int id, _) {
        cache[id] = _repository.fetchGameCover(id);

        return cache;
      },
      <int, Future<GameCoverModel>>{},
    );
  }

  ScanStreamTransformer<int, Map<int, Future<PlatformLogoModel>>>
      _platformLogoTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<PlatformLogoModel>>>(
      (Map<int, Future<PlatformLogoModel>> cache, int id, _) {
        cache[id] = _repository.fetchPlatformLogo(id);

        return cache;
      },
      <int, Future<PlatformLogoModel>>{},
    );
  }
}
