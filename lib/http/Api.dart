import 'dart:convert' as Convert;
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:quafulplayer/data/movie_detail_bean.dart';
import 'package:quafulplayer/data/movie_info_entity.dart';
import 'package:quafulplayer/data/search_response_entity.dart';
import 'package:synchronized/synchronized.dart' as sync;

typedef RequestCallBack<T> = void Function(T value);

class Api {
//  {
//  "id": 22696,
//  "url": "https://api.github.com/authorizations/22696",
//  "app": {
//  "name": "test-liang",
//  "url": "http://localhost:80",
//  "client_id": ""
//  },
//  "token": "",
//  "hashed_token": "9abc92d192d2b5cb43213c0b2ef63facb243aabcdbcd421fd1e10",
//  "token_last_eight": "6a975b37",
//  "note": "admin script",
//  "note_url": null,
//  "created_at": "2018-10-11T15:17:03Z",
//  "updated_at": "2018-10-11T15:17:03Z",
//  "scopes": [
//  "public_repo"
//  ],
//  "fingerprint": null
//  }

  static Api _instance;
  static String authorization;
  Dio dio;
  Dio trendingDio;
  bool testEvn = true;

  static const BASE_URL = "https://api.douban.com";

  Dio updateDio;

  Api._();

  static Api getInstance() {
    if (_instance == null) {
      _lock.synchronized(() {
        if (_instance == null) {
          // keep local instance till it is fully initialized
          var newInstance = new Api._();
          newInstance._init();
          _instance = newInstance;
        }
      });
    }
    return _instance;
  }

  static sync.Lock _lock = new sync.Lock();

  _init() {
    dio = new Dio();
    dio.options.connectTimeout = 20 * 1000;
    dio.options.receiveTimeout = 20 * 1000;
    dio.options.baseUrl = BASE_URL;
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // 在请求被发送之前做一些事情
      return options; //continue
      // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse: (Response response) {
      // 在返回响应数据之前做一些预处理
      var result =
          "{\"code\": 0, \"msg\" : \"ok\", \"data\":${Convert.jsonEncode(response.data)}}";
//      print('>>>>>result>>>>$result');
      response.data = Convert.jsonDecode(result);
      return response; // continue
    }, onError: (DioError e) {
      // 当请求失败时做一些预处理
      print(">>onError>>>>>>>>>>reqeust err------START----------");
      print('message:' + e.message + "][ error Request:" + e.request.path);
      print('message:' +
          e.message +
          "][ error Response:" +
          e.response.toString());
      print(">>onError>>>>>>>>>>reqeust err-----END-----------");

      return e; //continue
    }));
  }

  Future<List<SearchResponseData>> search({String search}) async {
    try {
      Response response = await dio.get('http://api.skyrj.com/api/movies?searchKey=' + search);
      return SearchResponseEntity.fromJson(response.data).data;
    } catch (e) {
      print('e=${e.toString()}');
      return null;
    }
  }

  Future<MovieInfoData> getMovieInfo({int id}) async {
    try {
      Response response = await dio.get('http://api.skyrj.com/api/movie?id=$id');
      return MovieInfoEntity.fromJson(response.data).data;
    } catch (e) {
      print('e=${e.toString()}');
      return null;
    }
  }



  Future<MovieDetailBean> getDoubanInfo(String subjectId) async{
    try {
      Response response = await dio.get('https://api.douban.com/v2/movie/subject/$subjectId?apikey=0b2bdeda43b5688921839c8ecb20399b');
      return MovieDetailBean.fromJson(response.data);
    } catch (e) {
      print('e=${e.toString()}');
      return null;
    }
  }
}
