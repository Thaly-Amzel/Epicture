import 'package:epicture/image_model.dart';
import 'package:epicture/imgur_api.dart';
import 'package:flutter/material.dart';
import 'package:epicture/exploration.dart';
import 'package:epicture/favorite_page.dart';
import 'drawer.dart';
import 'image_list.dart';

class HomePage extends StatefulWidget {
  final ImgurApi api;

  HomePage(this.api);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: "My Images",
        dispSearch: false,
        api: widget.api,
        showFavorite: false,
      ),
    );
  }

  _loadMyImages() async {
    images = await widget.api.fetchMyImages();
    setState(() {});
  }
}
