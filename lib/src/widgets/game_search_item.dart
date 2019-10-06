import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/game_cover_model.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/widgets/game_cover.dart';
import 'package:my_game_library/src/widgets/loading_game_cover.dart';

class GameSearchItem extends StatelessWidget {
  final GameModel game;

  GameSearchItem({
    this.game,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GamesBloc>(context);
    final gameCoverId = game.cover;

    return StreamBuilder(
      stream: bloc.gameCover,
      builder:
          (context, AsyncSnapshot<Map<int, Future<GameCoverModel>>> snapshot) {
        if (!snapshot.hasData || gameCoverId == null) {
          return _buildItem(game, null);
        }

        return FutureBuilder(
          future: snapshot.data[gameCoverId],
          builder: (context, AsyncSnapshot<GameCoverModel> coverSnapshot) {
            if (!coverSnapshot.hasData) {
              return _buildItem(game, null);
            }

            return _buildItem(game, coverSnapshot.data);
          },
        );
      },
    );
  }

  Widget _buildItem(GameModel game, GameCoverModel gameCover) {
    final gameCoverExists = gameCover != null;
    final width = 200.0;
    final height = 200.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: gameCoverExists
            ? GameCover(
                coverId: game.cover,
                width: 50,
              )
            : LoadingGameCover(),
        title: Text(
          game.name,
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }
}
