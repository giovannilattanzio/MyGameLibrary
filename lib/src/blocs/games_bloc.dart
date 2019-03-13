import 'package:rxdart/rxdart.dart';
import 'package:my_game_library/src/blocs/bloc_provider.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/repo/repository.dart';

export 'bloc_provider.dart';

class GamesBloc implements BlocBase {
  final _repository = Repository();
  final _gamesSubject = PublishSubject<List<GameModel>>();
//  final _indexAppBarSubject = BehaviorSubject<int>.seeded(0);
  final _isListLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Observable<List<GameModel>> get games => _gamesSubject.stream;
//  Observable<int> get indexAppBar => _indexAppBarSubject.stream;
  Observable<bool> get isListLoading => _isListLoadingSubject.stream;

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

//  void changeIndexAppBar(int index) {
//    _indexAppBarSubject.sink.add(index);
//  }

  @override
  void dispose() {
    _gamesSubject.close();
//    _indexAppBarSubject.close();
    _isListLoadingSubject.close();
  }

}
