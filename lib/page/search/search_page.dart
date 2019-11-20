import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quafulplayer/data/movie_detail_bean.dart';
import 'package:quafulplayer/data/search_response_entity.dart';
import 'package:quafulplayer/http/Api.dart';
import 'package:quafulplayer/page/detail/default_playlist_widget.dart';
import 'package:quafulplayer/page/detail/detail_page.dart';
import 'package:quafulplayer/util/color_utils.dart';
import 'package:quafulplayer/widget/cache_img_radius.dart';
import 'package:quafulplayer/widget/rating_bar.dart';

import '../../Routerj.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController;
  bool _searchIng = false;
  List<SearchResponseData> _list = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: CupertinoTheme.of(context).scaffoldBackgroundColor),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text('Search'),
                automaticallyImplyLeading: false,
                heroTag: this,
              ),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                      minHeight: 70.0,
                      maxHeight: 70.0,
                      child: Container(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withAlpha(246),
                        padding: const EdgeInsets.all(15.0),
                        child: CupertinoTextField(
                          onSubmitted: _onSubmitted,
                          controller: _textEditingController,
                          textInputAction: TextInputAction.search,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          prefix: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: _searchIcon(),
                          ),
                          decoration: BoxDecoration(
                            color: ColorUtils.inputBgColor(context),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0)),
                          ),
                          placeholder: 'Search Movies',
                        ),
                      ))),
              SliverPadding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 0.0,
                      childAspectRatio: 377.0 / 674.0),
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return _getItem(context, index);
                  }, childCount: _list == null ? 0 : _list.length),
                ),
              )
            ],
          ),
        ));
  }

  Widget _searchIcon() {
    if (_searchIng) {
      return SpinKitWave(
        type: SpinKitWaveType.center,
        duration: Duration(milliseconds: 1000),
        size: 19.0,
        itemBuilder: (_, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.blue : Colors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
          );
        },
      );
    } else {
      return Icon(
        Icons.search,
        color: const Color.fromARGB(255, 142, 141, 147),
      );
    }
  }

  void _onSubmitted(String value) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {});
    _search(value);
  }

  void _search(String value) async {
    List<SearchResponseData> list =
        await Api.getInstance().search(search: value);
    if (list != null) {
      _list = list;
      setState(() {});
    }
  }

  Widget _getItem(BuildContext context, int index) {
    var responseData = _list[index];
    return Column(
      children: <Widget>[
        Expanded(
          child: CacheImgRadius(
            radius: 5.0,
            imgUrl: responseData.cover ?? '',
            onTab: () {
              forwardDetail(context, responseData);
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          child: Text(
            responseData.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CupertinoTheme.of(context)
                .textTheme
                .textStyle
                .copyWith(fontSize: 15.0, fontWeight: FontWeight.w500),
          ),
          alignment: Alignment.centerLeft,
        ),
        Padding(
          child: RatingBar(
            responseData.score,
            size: 12.0,
          ),
          padding: const EdgeInsets.only(top: 5.0),
        ),
        SizedBox(
          height: 14,
        ),
      ],
    );
  }

  void forwardDetail(
      BuildContext context, SearchResponseData responseData) async {
    BuildContext dialogContext;
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return SpinKitCubeGrid(
            duration: Duration(milliseconds: 1000),
            size: 60.0,
            itemBuilder: (_, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.brown,
                    shape: BoxShape.rectangle),
              );
            },
          );
        });
    MovieDetailBean movieDetailBean =
        await Api.getInstance().getDoubanInfo(responseData.dBID);
    Router.pop(dialogContext);
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      if (movieDetailBean == null) {
        return DefaultPlayListPage(
          searchResponseData: responseData,
        );
      }
      return DetailPage(
        searchResponseData: responseData,
        movieDetailBean: movieDetailBean,
      );
    }));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
