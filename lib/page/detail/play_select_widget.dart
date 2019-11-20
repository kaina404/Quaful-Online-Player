import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quafulplayer/data/movie_info_entity.dart';
import 'package:quafulplayer/data/search_response_entity.dart';
import 'package:quafulplayer/http/Api.dart';
import 'package:quafulplayer/page/player/VideoPlayerPage.dart';
import 'package:quafulplayer/widget/my_button.dart';

import '../../Routerj.dart';

class PlaySelectWidget extends StatefulWidget {
  final SearchResponseData searchResponseData;

  const PlaySelectWidget({Key key, this.searchResponseData}) : super(key: key);

  @override
  _PlaySelectWidgetState createState() => _PlaySelectWidgetState();
}

class _PlaySelectWidgetState extends State<PlaySelectWidget> {
  SearchResponseData _searchResponseData;
  List<MovieInfoDataMovieplayurl> _moviePlayUrls;

  @override
  void initState() {
    super.initState();
    _searchResponseData = widget.searchResponseData;
    init();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return getItem(context, index);
      },
      itemCount: _moviePlayUrls == null ? 0 : _moviePlayUrls.length,
    );
  }

  void init() async {
    MovieInfoData movieInfoData =
        await Api.getInstance().getMovieInfo(id: _searchResponseData.iD);
    if (movieInfoData.moviePlayUrls != null) {
      _moviePlayUrls = movieInfoData.moviePlayUrls;
      setState(() {});
    }
  }

  Widget getItem(BuildContext context, int index) {
    MovieInfoDataMovieplayurl item = _moviePlayUrls[index];
    return MyCupertinoButton(
      minSize: 20,
      backgroundButtonPadding:  const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      child: Text(item.name ?? ''),
      onPressed: () {
        Router.push(context, VideoPlayerPage(url: item.playUrl));
      },
    );
  }
}
