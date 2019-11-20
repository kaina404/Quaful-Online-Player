
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef OnTab = void Function();

class CacheImgRadius extends StatelessWidget {
  final String imgUrl;
  final double radius, size;
  final OnTab onTab;
  final double ringWidth;
  final Widget placeholder;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  CacheImgRadius(
      {Key key,
      @required this.imgUrl,
      this.radius = 0.0,
      this.onTab,
      this.size,
      this.margin,
      this.padding,
      this.placeholder,
      this.ringWidth = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (size != null) {
      return Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            border: BorderDirectional(
              top: BorderSide(
                  color: Theme.of(context).dividerColor, width: ringWidth),
              start: BorderSide(
                  color: Theme.of(context).dividerColor, width: ringWidth),
              end: BorderSide(
                  color: Theme.of(context).dividerColor, width: ringWidth),
              bottom: BorderSide(
                  color: Theme.of(context).dividerColor, width: ringWidth),
            )),
        width: size,
        height: size,
        child: _getBody(context),
      );
    }
    return _getBody(context);
  }

  String defaultImg = 'assets/images/ic_default_img_subject_movie.9.png';

  Widget _getBody(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: imgUrl == null || imgUrl.isEmpty
            ? (placeholder == null
                ? Image.asset(defaultImg, fit: BoxFit.fill)
                : placeholder)
            : CachedNetworkImage(
                errorWidget: (BuildContext context, String url, Object error) {
                  return Image.asset(defaultImg, fit: BoxFit.fill);
                },
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String url) {
                  return placeholder == null
                      ? Image.asset(defaultImg, fit: BoxFit.fill,)
                      : placeholder;
                },
                imageUrl: imgUrl,
                fadeInDuration: const Duration(milliseconds: 50),
                fadeOutDuration: const Duration(milliseconds: 50),
              ),
      ),
      onTap: () {
        if (onTab != null) {
          onTab();
        }
      },
    );
  }
}
