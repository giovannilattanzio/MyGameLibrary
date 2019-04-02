import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/models/platform_model.dart';
import 'package:my_game_library/src/models/platform_logo_model.dart';
import 'package:my_game_library/src/widgets/game_card.dart';
import 'package:my_game_library/src/widgets/fab_bottom_appbar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Game Library"),
        centerTitle: true,
      ),
      body: _createBody(),
      bottomNavigationBar: FABBottomAppBar(
        items: <FABBottomAppBarItem>[
          FABBottomAppBarItem(
            iconData: Icons.home,
            text: "Home",
          ),
          FABBottomAppBarItem(
            iconData: Icons.favorite,
            text: "Preferiti",
          ),
        ],
        notchedShape: CircularNotchedRectangle(),
        color: Colors.blue,
        selectedColor: Colors.redAccent,
        onTabSelected: (index) {
          switch (index) {
//            case 0:
//              bloc.fetchGames(query: "zelda");
//              break;
//
//            case 1:
//              bloc.fetchLatestGames();
//              break;
//
//            case 2:
//              bloc.fetchFavoriteGames();
//              break;
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.search),
        elevation: 2.0,
      ),
    );
  }

  Widget _createBody() {
    return _listPlatforms();
  }

  Widget _listPlatforms() {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return StreamBuilder(
      stream: bloc.platforms,
      builder: (context, AsyncSnapshot<List<PlatformModel>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final PlatformModel platform = snapshot.data[index];

            final EdgeInsets padding = index == 0
                ? const EdgeInsets.only(
                    left: 16.0,
                    right: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                  )
                : const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                  );

            bloc.fetchPlatformLogo(platform.platformLogo);
            String fetcher = "platforms='${platform.id}'";
            bloc.fetchGames(fetcher);

            return Padding(
              padding: padding,
              child: Card(
                child: Container(
                  height: 250.0,
                  child: Stack(
                    children: <Widget>[
                      StreamBuilder(
                        stream: bloc.platformLogo,
                        builder: (context,
                            AsyncSnapshot<Map<int, Future<PlatformLogoModel>>>
                                snapshotLogo) {
                          if (!snapshotLogo.hasData ||
                              platform.platformLogo == null ||
                              snapshotLogo.data[platform.platformLogo] == null) {
                            return Text(platform.name);
                          }

                          return FutureBuilder(
                            future: snapshotLogo.data[platform.platformLogo],
                            builder: (context,
                                AsyncSnapshot<PlatformLogoModel> snapshotLogoData) {
                              if (!snapshotLogoData.hasData) {
                                return Container();
                              }

                              PlatformLogoModel platformLogo =
                                  snapshotLogoData.data;
                              return Image.network(platformLogo.imageUrlMed);

                            },
                          );
                        },
                      ),
                      _listGames(fetcher),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _listGames(String fetcher) {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return Positioned(
      bottom: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 200,
          width: 300,
          child: StreamBuilder(
            stream: bloc.games,
            builder: (context, AsyncSnapshot<Map<String, Future<List<GameModel>>>> snapshot) {

              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return FutureBuilder(
                future: snapshot.data[fetcher],
                builder: (context, AsyncSnapshot<List<GameModel>> snapshotGames) {
                  if (!snapshot.hasData ||
                      !snapshotGames.hasData) {
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
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshotGames.data.length,
                    itemBuilder: (context, index) {
                      final GameModel game = snapshotGames.data[index];
                      final lastGame = index == snapshotGames.data.length;

                      bloc.fetchGameCover(game.cover);

                      return Padding(
                        padding: lastGame ? 0.0 : const EdgeInsets.only(right: 8.0),
                        child: GameCard(game: game),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
