import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/models/game_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GamesBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Game Library"),
        centerTitle: true,
      ),
      body: _listGames(bloc),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            title: Text("Zelda"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            title: Text("Nuove uscite"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Preferiti"),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

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
    );
  }

  Widget _listGames(GamesBloc bloc) {
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

                return ListTile(
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
