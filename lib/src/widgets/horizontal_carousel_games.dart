import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/widgets/game_card.dart';

class HorizontalCarouselGames extends StatelessWidget {

  final String fetcher;

  HorizontalCarouselGames({this.fetcher});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return Container(
      height: 200,
      child: StreamBuilder(
        stream: bloc.games,
        builder: (context,
            AsyncSnapshot<Map<String, Future<List<GameModel>>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return FutureBuilder(
            future: snapshot.data[fetcher],
            builder: (context, AsyncSnapshot<List<GameModel>> snapshotGames) {
              if (!snapshot.hasData || !snapshotGames.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshotGames.data.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.warning,
                        size: 100.0,
                      ),
                      Text("Nessun gioco presente"),
                    ],
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshotGames.data.length,
                itemBuilder: (context, index) {
                  final GameModel game = snapshotGames.data[index];
                  final lastGame = index == snapshotGames.data.length;

                  bloc.fetchGameCover(game.cover);

                  return Padding(
                    padding:
                    lastGame ? 0.0 : const EdgeInsets.only(right: 8.0),
                    child: GameCard(
                      game: game,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
