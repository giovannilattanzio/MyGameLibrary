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
  final _gamesSubject = PublishSubject<List<GameModel>>();
  final _gameCoverFetcherSubject = PublishSubject<int>();
  final _gameCoverOutputSubject =
      BehaviorSubject<Map<int, Future<GameCoverModel>>>();

//  final _indexAppBarSubject = BehaviorSubject<int>.seeded(0);
  final _isListLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final _platformSubject = BehaviorSubject<List<PlatformModel>>();
  final _platformLogoFetcherSubject = PublishSubject<int>();
  final _platformLogoOutputSubject =
      BehaviorSubject<Map<int, Future<PlatformLogoModel>>>();

  Observable<List<GameModel>> get games => _gamesSubject.stream;

  Observable<Map<int, Future<GameCoverModel>>> get gameCover =>
      _gameCoverOutputSubject.stream;

//  Observable<int> get indexAppBar => _indexAppBarSubject.stream;
  Observable<bool> get isListLoading => _isListLoadingSubject.stream;

  Observable<List<PlatformModel>> get platforms => _platformSubject.stream;

  Observable<Map<int, Future<PlatformLogoModel>>> get platformLogo =>
      _platformLogoOutputSubject.stream;

  GamesBloc() {
    _gameCoverFetcherSubject.stream
        .transform(_gameCoverTransformer())
        .pipe(_gameCoverOutputSubject);

    _platformLogoFetcherSubject.stream
        .transform(_platformLogoTransformer())
        .pipe(_platformLogoOutputSubject);
  }

  void fetchGames({int id, String query}) async {
    _isListLoadingSubject.sink.add(true);
    final games = await _repository.fetchGames(id: id, query: query);
    _gamesSubject.sink.add(games);
    _isListLoadingSubject.sink.add(false);
  }

  void fetchLatestGames({String query}) async {
    _isListLoadingSubject.sink.add(true);
    final games = await _repository.fetchLatestGames(query: query);
    _gamesSubject.sink.add(games);
    _isListLoadingSubject.sink.add(false);
  }

  void fetchFavoriteGames({String query}) async {
    _isListLoadingSubject.sink.add(true);
    final games = await _repository.fetchFavoriteGames(query: query);
    _gamesSubject.sink.add(games);
    _isListLoadingSubject.sink.add(false);
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

  @override
  void dispose() {
    _gamesSubject.close();
    _gameCoverFetcherSubject.close();
    _gameCoverOutputSubject.close();
//    _indexAppBarSubject.close();
    _isListLoadingSubject.close();
    _platformSubject.close();
    _platformLogoFetcherSubject.close();
    _platformLogoOutputSubject.close();
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
