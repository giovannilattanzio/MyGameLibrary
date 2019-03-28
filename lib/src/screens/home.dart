import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/models/platform_model.dart';
import 'package:my_game_library/src/models/platform_logo_model.dart';
import 'package:my_game_library/src/widgets/game_cover.dart';
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
            case 0:
              bloc.fetchGames(query: "zelda");
              break;

            case 1:
              bloc.fetchLatestGames();
              break;

            case 2:
              bloc.fetchFavoriteGames();
              break;
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
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50.0,
                  child: _listPlatforms(),
                ),
                Expanded(
                  child: _listGames(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          scrollDirection: Axis.horizontal,
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

            return Padding(
              padding: padding,
              child: RaisedButton(
                child: StreamBuilder(
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

                        PlatformLogoModel platformLogo = snapshotLogoData.data;
                        return Image.network(platformLogo.imageUrlMed);
                      },
                    );
                  },
                ),
                onPressed: () {
                  debugPrint("Id platform ${platform.id}");
                  debugPrint("Nome platform ${platform.name}");
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _listGames() {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return StreamBuilder(
      stream: bloc.games,
      builder: (context, AsyncSnapshot<List<GameModel>> snapshot) {
        return StreamBuilder(
          stream: bloc.isListLoading,
          builder: (context, AsyncSnapshot<bool> snapshotLoading) {
            if (!snapshot.hasData ||
                !snapshotLoading.hasData ||
                snapshotLoading.data) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data.length == 0) {
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
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final GameModel game = snapshot.data[index];

                bloc.fetchGameCover(game.cover);

                return ListTile(
                  leading: GameCover(
                    coverId: game.cover,
                  ),
                  title: Text(game.name),
                );
              },
            );
          },
        );
      },
    );
  }
}
