import 'package:quafulplayer/data/movie_info_entity.dart';
import 'package:quafulplayer/data/search_response_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "MovieInfoEntity") {
      return MovieInfoEntity.fromJson(json) as T;
    } else if (T.toString() == "SearchResponseEntity") {
      return SearchResponseEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}