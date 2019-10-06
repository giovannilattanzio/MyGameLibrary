import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/widgets/searching_games_results.dart';

class GameSearch extends SearchDelegate<GameModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(query.isEmpty) {
      return Container();
    }

    final bloc = BlocProvider.of<GamesBloc>(context);
    String fetcher = 'name ~ *"$query"*';

    bloc.fetchGames(fetcher);

    return SearchingGamesResults(fetcher: fetcher);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
