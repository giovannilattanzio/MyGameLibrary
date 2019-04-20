import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/platform_model.dart';
import 'package:my_game_library/src/widgets/fab_bottom_appbar.dart';
import 'package:my_game_library/src/widgets/games_platform_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
}
