import 'dart:convert';
import 'package:my_game_library/src/utils/igdb/igdb_games.dart';
import 'package:my_game_library/src/utils/sqflite/db_personal_game_fields.dart';

/// Classe di model di un gioco
class GameModel {
  final int id;
  final double aggregatedRating;
  final List<dynamic> artworks;
  final int category;
  final int cover;
  final List<dynamic> genres;
  final String name;
  final List<dynamic> platforms;
  final double popularity;
  final double rating;
  final List<dynamic> screenshots;
  final List<dynamic> similarGames;
  final String slug; //A url-safe, unique, lower-case version of the name
  final String storyline;
  final String summary;
  final List<dynamic> themes;
  final double totalRating;
  final List<dynamic> videos;
  final List<dynamic> websites;
  final bool favorite;

  /// Named contructor che, partendo da un json decodificato, mappa tutti i campi della classe
  GameModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson[IGDBGameFields.id],
        aggregatedRating = parsedJson[IGDBGameFields.aggregated_rating],
        artworks = parsedJson[IGDBGameFields.artworks] ?? [],
        category = parsedJson[IGDBGameFields.category],
        cover = parsedJson[IGDBGameFields.cover],
        genres = parsedJson[IGDBGameFields.genres] ?? [],
        name = parsedJson[IGDBGameFields.name],
        platforms = parsedJson[IGDBGameFields.platforms] ?? [],
        popularity = parsedJson[IGDBGameFields.popularity],
        rating = parsedJson[IGDBGameFields.rating],
        screenshots = parsedJson[IGDBGameFields.screenshots] ?? [],
        similarGames = parsedJson[IGDBGameFields.similar_games] ?? [],
        slug = parsedJson[IGDBGameFields.slug],
        storyline = parsedJson[IGDBGameFields.storyline],
        summary = parsedJson[IGDBGameFields.summary],
        themes = parsedJson[IGDBGameFields.themes] ?? [],
        totalRating = parsedJson[IGDBGameFields.total_rating],
        videos = parsedJson[IGDBGameFields.videos] ?? [],
        websites = parsedJson[IGDBGameFields.websites] ?? [],
        favorite = parsedJson[DBPersonalGameFields.favorite] ?? false;

  /// Named contructor che, partendo da un record recuperato dal database [Sqflite], mappa tutti i campi della classe
  GameModel.fromDB(Map<String, dynamic> map)
      : id = map[IGDBGameFields.id],
        aggregatedRating = map[IGDBGameFields.aggregated_rating],
        artworks = jsonDecode(map[IGDBGameFields.artworks]),
        category = map[IGDBGameFields.category],
        cover = map[IGDBGameFields.cover],
        genres = jsonDecode(map[IGDBGameFields.genres]),
        name = map[IGDBGameFields.name],
        platforms = jsonDecode(map[IGDBGameFields.platforms]),
        popularity = map[IGDBGameFields.popularity],
        rating = map[IGDBGameFields.rating],
        screenshots = jsonDecode(map[IGDBGameFields.screenshots]),
        similarGames = jsonDecode(map[IGDBGameFields.similar_games]),
        slug = map[IGDBGameFields.slug],
        storyline = map[IGDBGameFields.storyline],
        summary = map[IGDBGameFields.summary],
        themes = jsonDecode(map[IGDBGameFields.themes]),
        totalRating = map[IGDBGameFields.total_rating],
        videos = jsonDecode(map[IGDBGameFields.videos]),
        websites = jsonDecode(map[IGDBGameFields.websites]),
        favorite = map[DBPersonalGameFields.favorite] == 1;

  /// Metodo per mappare i campi della classe e restituire un [Map] di tipo [String] come chiave e [dynamic] come valore
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      IGDBGameFields.id: id,
      IGDBGameFields.aggregated_rating: aggregatedRating,
      IGDBGameFields.artworks: jsonEncode(artworks),
      IGDBGameFields.category: category,
      IGDBGameFields.cover: cover,
      IGDBGameFields.genres: jsonEncode(genres),
      IGDBGameFields.name: name,
      IGDBGameFields.platforms: jsonEncode(platforms),
      IGDBGameFields.popularity: popularity,
      IGDBGameFields.rating: rating,
      IGDBGameFields.screenshots: jsonEncode(screenshots),
      IGDBGameFields.similar_games: jsonEncode(similarGames),
      IGDBGameFields.slug: slug,
      IGDBGameFields.storyline: storyline,
      IGDBGameFields.summary: summary,
      IGDBGameFields.themes: jsonEncode(themes),
      IGDBGameFields.total_rating: totalRating,
      IGDBGameFields.videos: jsonEncode(videos),
      IGDBGameFields.websites: jsonEncode(websites),
      DBPersonalGameFields.favorite: favorite ? 1 : 0,
    };
  }
}
