import 'package:test_api/test_api.dart';
import 'package:my_game_library/src/models/game_model.dart';

void main() {
  test("GameModel.fromJson", () async {
    final jsonMap = {
      "id": 1025,
      "age_ratings": [7635, 14180],
      "alternative_names": [5436, 21583],
      "bundles": [45139],
      "category": 0,
      "collection": 106,
      "cover": 65640,
      "created_at": 1326240000,
      "external_games": [142246, 246144],
      "first_release_date": 537580800,
      "game_modes": [1],
      "genres": [12, 31],
      "involved_companies": [54028, 54029],
      "keywords": [
        121,
        14114,
        14195,
        15079,
        15193,
        15404
      ],
      "name": "Zelda II: The Adventure of Link",
      "platforms": [5, 18, 21, 24, 37, 41, 47, 51],
      "player_perspectives": [4],
      "popularity": 3.304740634826235,
      "pulse_count": 9,
      "rating": 73.7361798325965,
      "rating_count": 96,
      "release_dates": [
        2502,
        145034,
        145035
      ],
      "screenshots": [
        19444,
        179236
      ],
      "similar_games": [
        358,
        11763
      ],
      "slug": "zelda-ii-the-adventure-of-link",
      "summary":
          "The land of Hyrule is in chaos. As Link, you’ll be sent on a treacherous journey to return six precious Crystals to their origins in six stone statues. Only by defeating the guardians of the six palaces will you gain passage to the seventh palace, take on the ultimate challenge that awaits you, and wake the Princess Zelda from her sleeping spell. On your way, helpful villagers you encounter will offer clues and secret messages invaluable in your quest. As you guide Link through the levels of Hyrule, close-ups and overviews will enhance your video vision. Are you up to the challenge?",
      "tags": [
        1,
        536886316
      ],
      "themes": [1, 17, 33],
      "total_rating": 73.7361798325965,
      "total_rating_count": 96,
      "updated_at": 1551139200,
      "url": "https://www.igdb.com/games/zelda-ii-the-adventure-of-link",
      "videos": [713],
      "websites": [4877, 4878]
    };

    final game = GameModel.fromJson(jsonMap);

    expect(game.name, "Zelda II: The Adventure of Link");
  });
}
