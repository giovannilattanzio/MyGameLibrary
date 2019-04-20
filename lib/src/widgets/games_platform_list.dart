import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/platform_logo_model.dart';
import 'package:my_game_library/src/models/platform_model.dart';
import 'package:my_game_library/src/widgets/horizontal_carousel_games.dart';

class GamesPlatformList extends StatelessWidget {
  final int index;
  final String fetcher;
  final PlatformModel platform;
  final EdgeInsets _padding;

  GamesPlatformList({this.index, this.platform, this.fetcher})
      : _padding = index == 0
            ? const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 8.0,
                bottom: 4.0,
              )
            : const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 4.0,
                bottom: 8.0,
              );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Card(
        color: Colors.amber,
        child: Container(
          height: 290,
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _platformTitle(context),
              Container(
                height: 8.0,
              ),
              _listGames(fetcher),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listGames(String fetcher) {
    return HorizontalCarouselGames(fetcher: fetcher);
  }

  Widget _platformTitle(BuildContext context) {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return Container(
      height: 60.0,
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder(
                stream: bloc.platformLogo,
                builder: (context,
                    AsyncSnapshot<Map<int, Future<PlatformLogoModel>>>
                        snapshotLogo) {
                  if (!snapshotLogo.hasData ||
                      platform.platformLogo == null ||
                      snapshotLogo.data[platform.platformLogo] == null) {
                    return Container();
                  }

                  return FutureBuilder(
                    future: snapshotLogo.data[platform.platformLogo],
                    builder: (context,
                        AsyncSnapshot<PlatformLogoModel> snapshotLogoData) {
                      if (!snapshotLogoData.hasData) {
                        return Container();
                      }

                      PlatformLogoModel platformLogo = snapshotLogoData.data;

                      return Container(
                        width: 60.0,
                        child: Image.network(platformLogo.imageUrlMed),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          Center(
            child: Text(
              platform.name,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ],
      ),
    );
  }
}
