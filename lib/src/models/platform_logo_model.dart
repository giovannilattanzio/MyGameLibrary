import 'dart:convert';
import 'package:my_game_library/src/utils/igdb/igdb_platforms.dart';

/// Classe di model di un logo di una piattaforma
class PlatformLogoModel {
  final int id;
  final bool alphaChannel;
  final bool animated;
  final int height;
  final String imageId;
  final String url;
  final int width;

  /// Named contructor che, partendo da un json decodificato, mappa tutti i campi della classe
  PlatformLogoModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson[IGDBPlatformLogoFields.id],
        alphaChannel = parsedJson[IGDBPlatformLogoFields.alpha_channel] ?? false,
        animated = parsedJson[IGDBPlatformLogoFields.animated] ?? false,
        height = parsedJson[IGDBPlatformLogoFields.height],
        imageId = parsedJson[IGDBPlatformLogoFields.image_id],
        url = parsedJson[IGDBPlatformLogoFields.url],
        width = parsedJson[IGDBPlatformLogoFields.width];

  /// Named contructor che, partendo da un record recuperato dal database [Sqflite], mappa tutti i campi della classe
  PlatformLogoModel.fromDB(Map<String, dynamic> map)
      : id = map[IGDBPlatformLogoFields.id],
        alphaChannel = map[IGDBPlatformLogoFields.alpha_channel] == 1,
        animated = map[IGDBPlatformLogoFields.animated] == 1,
        height = map[IGDBPlatformLogoFields.height],
        imageId = map[IGDBPlatformLogoFields.image_id],
        url = map[IGDBPlatformLogoFields.url],
        width = map[IGDBPlatformLogoFields.width];

  /// Metodo per mappare i campi della classe e restituire un [Map] di tipo [String] come chiave e [dynamic] come valore
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      IGDBPlatformFields.id: id,
      IGDBPlatformLogoFields.alpha_channel: alphaChannel ? 1 : 0,
      IGDBPlatformLogoFields.animated: animated ? 1 : 0,
      IGDBPlatformLogoFields.height: height,
      IGDBPlatformLogoFields.image_id: imageId,
      IGDBPlatformLogoFields.url: url,
      IGDBPlatformLogoFields.width: width,
    };
  }
}
