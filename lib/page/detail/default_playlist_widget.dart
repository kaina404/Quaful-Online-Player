import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quafulplayer/data/movie_info_entity.dart';
import 'package:quafulplayer/data/search_response_entity.dart';
import 'package:quafulplayer/http/Api.dart';
import 'package:quafulplayer/page/player/VideoPlayerPage.dart';
import 'package:quafulplayer/widget/cache_img_radius.dart';
import 'package:quafulplayer/widget/loading_widget.dart';
import 'package:quafulplayer/widget/my_button.dart';

import '../../Routerj.dart';

class DefaultPlayListPage extends StatefulWidget {
  final SearchResponseData searchResponseData;

  const DefaultPlayListPage({Key key, this.searchResponseData})
      : super(key: key);

  @override
  _DefaultPlayListPageState createState() => _DefaultPlayListPageState();
}

class _DefaultPlayListPageState extends State<DefaultPlayListPage> {
  SearchResponseData _searchResponseData;
  List<MovieInfoDataMovieplayurl> _moviePlayUrls;
  String imgUrl;

  @override
  void initState() {
    super.initState();
    _searchResponseData = widget.searchResponseData;
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            SizedBox(
              child: CacheImgRadius(
                radius: 10,
                imgUrl: imgUrl,
              ),
              height: 400,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: getList(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  void init() async {
    MovieInfoData movieInfoData =
        await Api.getInstance().getMovieInfo(id: _searchResponseData.iD);
    if (movieInfoData.moviePlayUrls != null) {
      _moviePlayUrls = movieInfoData.moviePlayUrls;
      imgUrl = movieInfoData.cover;
      setState(() {});
    }
  }

  Widget getItem(BuildContext context, int index) {
    MovieInfoDataMovieplayurl item = _moviePlayUrls[index];
    return MyCupertinoButton(
      minSize: 20,
      backgroundButtonPadding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      child: Text(item.name ?? ''),
      onPressed: () {
        Router.push(context, VideoPlayerPage(url: item.playUrl));
      },
    );
  }

  getList(BuildContext context) {
    if (_moviePlayUrls == null) {
      return LoadingWidget.getLoading();
    } else if (_moviePlayUrls.length > 5) {
      return GridView.builder(
        itemCount: _moviePlayUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return getItem(context, index);
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //单个子Widget的水平最大宽度
            maxCrossAxisExtent: 100,
            //水平单个子Widget之间间距
            mainAxisSpacing: 20.0,
            childAspectRatio: 2.0,
            //垂直单个子Widget之间间距
            crossAxisSpacing: 10.0),
      );
    } else
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(30),
            child: getItem(context, index),
          );
        },
        itemCount: _moviePlayUrls == null ? 0 : _moviePlayUrls.length,
      );
  }
}
