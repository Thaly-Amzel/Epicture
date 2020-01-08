import 'package:epicture/image_list.dart';
import 'package:epicture/image_model.dart';
import 'package:epicture/imgur_api.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';

class FavoritePage extends StatefulWidget {
  final ImgurApi api;
  FavoritePage(this.api);
  @override
  State<StatefulWidget> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<ImageModel> images;
  @override
  void initState() {
    super.initState();
    _loadMyImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: draw(context, widget.api),
      body: ImageList(
        images: images,
        title: "Favorite",
        dispSearch: false,
        showFavorite: false,
        api: widget.api,
      ),
    );
  }

  _loadMyImages() async {
    images = await widget.api.getFavorite();
    setState(() {});
  }
}
