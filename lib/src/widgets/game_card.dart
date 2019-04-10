import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/game_cover_model.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/widgets/game_cover.dart';
import 'package:my_game_library/src/widgets/loading_game_cover.dart';

class GameCard extends StatelessWidget {
  final GameModel game;

  GameCard({
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
          return _buildCard(game, null);
        }

        return FutureBuilder(
          future: snapshot.data[gameCoverId],
          builder: (context, AsyncSnapshot<GameCoverModel> coverSnapshot) {
            if (!coverSnapshot.hasData) {
              return _buildCard(game, null);
            }

            return _buildCard(game, coverSnapshot.data);
          },
        );
      },
    );
  }

  Widget _buildCard(GameModel game, GameCoverModel gameCover) {
    final gameCoverExists = gameCover != null;
    final width = 200.0;
    final height = 200.0;

    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              child: FittedBox(
                fit: (gameCoverExists && gameCover.width > gameCover.height)
                    ? BoxFit.fitHeight
                    : BoxFit.fitWidth,
                child: gameCoverExists
                    ? GameCover(
                        coverId: game.cover,
                      )
                    : LoadingGameCover(),
              ),
            ),
            Positioned(
              bottom: 5.0,
              child: Center(
                child: Container(
                  width: width,
                  alignment: Alignment(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      game.name,
                      style: TextStyle(
                          color: gameCoverExists ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
