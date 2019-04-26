import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/game_model.dart';
import 'package:my_game_library/src/models/platform_model.dart';
import 'package:my_game_library/src/widgets/fab_bottom_appbar.dart';
import 'package:my_game_library/src/widgets/game_card.dart';
import 'package:my_game_library/src/widgets/games_platform_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<GamesBloc>(context);

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
              _bloc.fetchPlatforms();
              break;

            case 1:
              _bloc.fetchFavouriteGames();
              break;
          }

          setState(() {
            _index = index;
          });
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
    switch (_index) {
      case 0:
        return _listPlatforms();
        break;
      case 1:
        return _listFavourites();
        break;
    }
  }

  Widget _listPlatforms() {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return StreamBuilder(
      stream: bloc.platforms,
      builder: (context, AsyncSnapshot<List<PlatformModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final PlatformModel platform = snapshot.data[index];

            bloc.fetchPlatformLogo(platform.platformLogo);
            String fetcher = "platforms='${platform.id}'";
            bloc.fetchGames(fetcher);

            return GamesPlatformList(
              index: index,
              platform: platform,
              fetcher: fetcher,
            );
          },
        );
      },
    );
  }

  Widget _listFavourites() {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return StreamBuilder(
      stream: bloc.favouriteGames,
      builder: (context, AsyncSnapshot<List<GameModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: snapshot.data.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 10.0,
              maxCrossAxisExtent: 200.0,
              crossAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              final GameModel game = snapshot.data[index];

              bloc.fetchGameCover(game.cover);

              return GameCard(
                game: game,
              );
            },
          ),
        );
      },
    );
  }
}
