import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/game_cover_model.dart';
import 'package:my_game_library/src/widgets/loading_game_cover.dart';

class GameCover extends StatelessWidget {
  final int coverId;
  final double width;
  final double height;

  GameCover({
    this.coverId,
    this.width = 50.0,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return StreamBuilder(
      stream: bloc.gameCover,
      builder:
          (context, AsyncSnapshot<Map<int, Future<GameCoverModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingGameCover(
            width: width,
            height: height,
          );
        }

        return FutureBuilder(
          future: snapshot.data[coverId],
          builder: (context, AsyncSnapshot<GameCoverModel> coverSnapshot) {
            if (!coverSnapshot.hasData) {
              return LoadingGameCover(
                width: width,
                height: height,
              );
            }

            return _buildCover(coverSnapshot.data);
          },
        );
      },
    );
  }

  Widget _buildCover(GameCoverModel cover) {
    return Image.network(
      cover.imageUrlMed,
      width: width,
      height: height,
    );
  }
}
