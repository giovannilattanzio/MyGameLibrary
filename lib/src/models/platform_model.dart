import 'dart:convert';
import 'package:my_game_library/src/utils/igdb/igdb_platforms.dart';
import 'package:my_game_library/src/utils/sqflite/db_personal_game_fields.dart';

/// Classe di model di una piattaforma
class PlatformModel {
  final int id;
  final String abbreviation;
  final String alternativeName;
  final int category;
  final int createdAt;
  final int generation;
  final String name;
  final int platformLogo;
  final int productFamily;
  final String slug;
  final String summary;
  final int updatedAt;
  final String url;
  final List<dynamic> versions;
  final List<dynamic> websites;
  int orderNumber;

  /// Named contructor che, partendo da un json decodificato, mappa tutti i campi della classe
  PlatformModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson[IGDBPlatformFields.id],
        abbreviation = parsedJson[IGDBPlatformFields.abbreviation],
        alternativeName = parsedJson[IGDBPlatformFields.alternative_name],
        category = parsedJson[IGDBPlatformFields.category],
        createdAt = parsedJson[IGDBPlatformFields.created_at],
        generation = parsedJson[IGDBPlatformFields.generation],
        name = parsedJson[IGDBPlatformFields.name],
        platformLogo = parsedJson[IGDBPlatformFields.platform_logo],
        productFamily = parsedJson[IGDBPlatformFields.product_family],
        slug = parsedJson[IGDBPlatformFields.slug],
        summary = parsedJson[IGDBPlatformFields.summary],
        updatedAt = parsedJson[IGDBPlatformFields.updated_at],
        url = parsedJson[IGDBPlatformFields.url],
        versions = parsedJson[IGDBPlatformFields.versions] ?? [],
        websites = parsedJson[IGDBPlatformFields.websites] ?? [],
        orderNumber = parsedJson[DBPersonalGameFields.order_number] ?? 0;

  /// Named contructor che, partendo da un record recuperato dal database [Sqflite], mappa tutti i campi della classe
  PlatformModel.fromDB(Map<String, dynamic> map)
      : id = map[IGDBPlatformFields.id],
        abbreviation = map[IGDBPlatformFields.abbreviation],
        alternativeName = map[IGDBPlatformFields.alternative_name],
        category = map[IGDBPlatformFields.category],
        createdAt = map[IGDBPlatformFields.created_at],
        generation = map[IGDBPlatformFields.generation],
        name = map[IGDBPlatformFields.name],
        platformLogo = map[IGDBPlatformFields.platform_logo],
        productFamily = map[IGDBPlatformFields.product_family],
        slug = map[IGDBPlatformFields.slug],
        summary = map[IGDBPlatformFields.summary],
        updatedAt = map[IGDBPlatformFields.updated_at],
        url = map[IGDBPlatformFields.url],
        versions = jsonDecode(map[IGDBPlatformFields.versions]),
        websites = jsonDecode(map[IGDBPlatformFields.websites]),
        orderNumber = map[DBPersonalGameFields.order_number];

  /// Metodo per mappare i campi della classe e restituire un [Map] di tipo [String] come chiave e [dynamic] come valore
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      IGDBPlatformFields.id: id,
      IGDBPlatformFields.abbreviation: abbreviation,
      IGDBPlatformFields.alternative_name: alternativeName,
      IGDBPlatformFields.category: category,
      IGDBPlatformFields.created_at: createdAt,
      IGDBPlatformFields.generation: generation,
      IGDBPlatformFields.name: name,
      IGDBPlatformFields.platform_logo: platformLogo,
      IGDBPlatformFields.product_family: productFamily,
      IGDBPlatformFields.slug: slug,
      IGDBPlatformFields.summary: summary,
      IGDBPlatformFields.updated_at: updatedAt,
      IGDBPlatformFields.url: url,
      IGDBPlatformFields.versions: jsonEncode(versions),
      IGDBPlatformFields.websites: jsonEncode(websites),
      DBPersonalGameFields.order_number: orderNumber,
    };
  }
}
