import 'package:flutter/material.dart';
import 'package:my_game_library/src/blocs/games_bloc.dart';
import 'package:my_game_library/src/screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: GamesBloc(),
      child: MaterialApp(
        title: "My Game Library",
        onGenerateRoute: route,
      ),
    );
  }

  Route route(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {

          final _bloc = BlocProvider.of<GamesBloc>(context);
          _bloc.fetchPlatforms();

          return Home();
        },
      );
    }
  }
}
