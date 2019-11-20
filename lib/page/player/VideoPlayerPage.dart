import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quafulplayer/util/screen_utils.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

import '../../Routerj.dart';

class VideoPlayerPage extends StatefulWidget {
  final String url;

  const VideoPlayerPage({Key key, this.url}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController controller;
  VoidCallback listener;
  bool hideBottom = true;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
    controller = VideoPlayerController.network(widget.url);
    controller.initialize();
    controller.setLooping(true);
    controller.addListener(listener);
    controller.play();
    Screen.keepOn(true);
    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    Screen.keepOn(false);
    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PlayView(
          controller,
          allowFullScreen: !isFullScreen,
          url: widget.url,
        ),
      ),
    );
  }
}

class PlayView extends StatefulWidget {
  final String url;
  VideoPlayerController controller;
  bool allowFullScreen;

  PlayView(this.controller, {this.allowFullScreen: true, this.url});

  @override
  _PlayViewState createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {
  VideoPlayerController get controller => widget.controller;
  bool hideBottom = true;

  void onClickPlay() {
    if (!controller.value.initialized) {
      return;
    }
    setState(() {
      hideBottom = false;
    });
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) {
          return;
        }
        if (!controller.value.initialized) {
          return;
        }
        if (controller.value.isPlaying && !hideBottom) {
          setState(() {
            hideBottom = true;
          });
        }
      });
      controller.play();
    }
  }

  void onClickFullScreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      // current portrait , enter fullscreen
      SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      Navigator.of(context)
          .push(PageRouteBuilder(
        settings: RouteSettings(isInitialRoute: false),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              return Scaffold(
                resizeToAvoidBottomPadding: false,
                body: PlayView(controller),
              );
            },
          );
        },
      ))
          .then((value) {
        // exit fullscreen
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      });
    }
  }

  void onClickExitFullScreen() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      // current landscape , exit fullscreen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    if (controller.value.initialized) {
      final Size size = controller.value.size;
      return GestureDetector(
        child: Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Center(
                    child: AspectRatio(
                  aspectRatio: size.width / size.height,
                  child: VideoPlayer(controller),
                )),
                Padding(
                  child: getBottomControlView(primaryColor),
                  padding: const EdgeInsets.only(bottom: 30),
                ),
                Align(
                  alignment: Alignment.center,
                  child: controller.value.isPlaying
                      ? Container()
                      : Icon(
                          Icons.play_circle_filled,
                          color: primaryColor,
                          size: 48.0,
                        ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                      onPressed: () {
//                    ClipboardData data2 = new ClipboardData(text: widget.url);
//                    Clipboard.setData(data2);
//                    Fluttertoast.showToast(msg: "Copied Play Url Successful");
                        _showMoreDialog(context);
                      },
                    ))
              ],
            )),
        onTap: onClickPlay,
      );
    } else if (controller.value.hasError && !controller.value.isPlaying) {
      return Container(
        color: Colors.black,
        child: Center(
          child: RaisedButton(
            onPressed: () {
              controller.initialize();
              controller.setLooping(true);
              controller.play();
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: Text("play error, try again!"),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  //显示更多选项
  void _showMoreDialog(BuildContext context) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext dialogContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return _dialogBody(dialogContext, context);
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Color(0x00000001),
      transitionDuration: const Duration(milliseconds: 100),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    print(animation.value);
    return Transform.translate(
        offset: Offset(0.0, (animation.value - 0.7) * -120), child: child);
  }

  _dialogBody(BuildContext dialogContext, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        padding: const EdgeInsets.all(10.0),
        width: ScreenUtils.screenW(),
        height: 80.0,
        child: Card(
          color: Theme.of(context).primaryColor,
          //z轴的高度，设置card的阴影
          elevation: 10.0,
          //设置shape，这里设置成了R角
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
          clipBehavior: Clip.antiAlias,
          semanticContainer: false,
          child: ListView.custom(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              childrenDelegate: SliverChildListDelegate([
                FlatButton.icon(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).cardColor,
                    ),
                    label: Container()),
                FlatButton.icon(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Router.openBrowser(widget.url);
                    },
                    icon: Icon(
                      Icons.explore,
                      color: Theme.of(context).cardColor,
                    ),
                    label: Container()),
                FlatButton.icon(
                    onPressed: () {
                      ClipboardData data2 = new ClipboardData(text: widget.url);
                      Clipboard.setData(data2);
                      Navigator.of(dialogContext).pop();
                      Fluttertoast.showToast(msg: "Copied Successful");
                    },
                    icon: Icon(
                      Icons.link,
                      color: Theme.of(context).cardColor,
                    ),
                    label: Container()),

              ])),
        ),
      ),
    );
  }

  getBottomControlView(Color primaryColor) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: hideBottom
            ? Container()
            : Opacity(
                opacity: 0.8,
                child: Container(
                    height: 30.0,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            child: controller.value.isPlaying
                                ? Icon(
                                    Icons.pause,
                                    color: primaryColor,
                                  )
                                : Icon(
                                    Icons.play_arrow,
                                    color: primaryColor,
                                  ),
                          ),
                          onTap: onClickPlay,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Center(
                              child: Text(
                                "${controller.value.position.toString().split(".")[0]}",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        Expanded(
                            child: VideoProgressIndicator(
                          controller,
                          allowScrubbing: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.0, vertical: 1.0),
                          colors:
                              VideoProgressColors(playedColor: primaryColor),
                        )),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Center(
                              child: Text(
                                "${controller.value.duration.toString().split(".")[0]}",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        Container(
                          child: widget.allowFullScreen
                              ? Container(
                                  child: MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? GestureDetector(
                                          child: Icon(
                                            Icons.fullscreen,
                                            color: primaryColor,
                                          ),
                                          onTap: onClickFullScreen,
                                        )
                                      : GestureDetector(
                                          child: Icon(
                                            Icons.fullscreen_exit,
                                            color: primaryColor,
                                          ),
                                          onTap: onClickExitFullScreen,
                                        ),
                                )
                              : Container(),
                        )
                      ],
                    )),
              ));
  }
}
