import 'package:epicture/imgur_api.dart';
import 'package:epicture/page_home.dart';
import 'package:epicture/image_model.dart';
import 'package:flutter/material.dart';
import 'package:epicture/url_launch.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImgurImgWidget extends StatefulWidget {
  final ImgurApi api;
  final ImageModel image;
  final bool showFavorite;

  ImgurImgWidget(this.api, this.image, this.showFavorite);

  @override
  State<StatefulWidget> createState() => _ImgurImgWidgetState();
}

class _ImgurImgWidgetState extends State<ImgurImgWidget> {
  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: widget.image.url == null
            ? Container()
            : Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: widget.image.url,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ],
              ),
      ),
    );
  }
}
