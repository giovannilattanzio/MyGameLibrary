import 'package:flutter/material.dart';
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Column(
        children: <Widget>[
          Container(
            width: 200.0,
            height: 200.0,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: game.cover == null
                  ? LoadingGameCover()
                  : GameCover(
                      coverId: game.cover,
                    ),
            ),
          ),
          Text(game.name),
        ],
      ),
    );
  }
}
