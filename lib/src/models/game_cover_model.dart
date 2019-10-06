import 'package:igdb_client/igdb_client.dart';
import 'package:my_game_library/src/utils/igdb/igdb_games.dart';

/// Classe di model di una cover di un gioco
class GameCoverModel {
  final int id;
  final bool alphaChannel;
  final bool animated;
  final int game;
  final int height;
  final String imageId;
  final String url;
  final int width;

  /// Named contructor che, partendo da un json decodificato, mappa tutti i campi della classe
  GameCoverModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson[IGDBGameCoverFields.id],
        alphaChannel =
            parsedJson[IGDBGameCoverFields.alpha_channel] ?? false,
        animated = parsedJson[IGDBGameCoverFields.animated] ?? false,
        game = parsedJson[IGDBGameCoverFields.game],
        height = parsedJson[IGDBGameCoverFields.height],
        imageId = parsedJson[IGDBGameCoverFields.image_id],
        url = parsedJson[IGDBGameCoverFields.url],
        width = parsedJson[IGDBGameCoverFields.width];

  /// Named contructor che, partendo da un record recuperato dal database [Sqflite], mappa tutti i campi della classe
  GameCoverModel.fromDB(Map<String, dynamic> map)
      : id = map[IGDBGameCoverFields.id],
        alphaChannel = map[IGDBGameCoverFields.alpha_channel] == 1,
        animated = map[IGDBGameCoverFields.animated] == 1,
        game = map[IGDBGameCoverFields.game],
        height = map[IGDBGameCoverFields.height],
        imageId = map[IGDBGameCoverFields.image_id],
        url = map[IGDBGameCoverFields.url],
        width = map[IGDBGameCoverFields.width];

  /// Metodo per mappare i campi della classe e restituire un [Map] di tipo [String] come chiave e [dynamic] come valore
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      IGDBGameCoverFields.id: id,
      IGDBGameCoverFields.alpha_channel: alphaChannel ? 1 : 0,
      IGDBGameCoverFields.animated: animated ? 1 : 0,
      IGDBGameCoverFields.game: game,
      IGDBGameCoverFields.height: height,
      IGDBGameCoverFields.image_id: imageId,
      IGDBGameCoverFields.url: url,
      IGDBGameCoverFields.width: width,
    };
  }

  String get imageUrlSmall =>
      IGDBHelpers.getImageUrl(imageId, IGDBImageSizes.COVER_SMALL, alphaChannel: alphaChannel);
  String get imageUrlMed =>
      IGDBHelpers.getImageUrl(imageId, IGDBImageSizes.LOGO_MED, alphaChannel: alphaChannel);
  String get imageUrlBig =>
      IGDBHelpers.getImageUrl(imageId, IGDBImageSizes.COVER_BIG, alphaChannel: alphaChannel);
  String get imageUrlSmall2x =>
      IGDBHelpers.getImageUrl(imageId, IGDBImageSizes.COVER_SMALL, isRetina: true, alphaChannel: alphaChannel);
  String get imageUrlMed2x =>
      IGDBHelpers.getImageUrl(imageId, IGDBImageSizes.LOGO_MED, isRetina: true, alphaChannel: alphaChannel);
  String get imageUrlBig2x =>
      IGDBHelpers.getImageUrl(imageId, IGDBImageSizes.COVER_BIG, isRetina: true, alphaChannel: alphaChannel);
}
