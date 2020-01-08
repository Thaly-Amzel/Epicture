import 'package:epicture/image_list.dart';
import 'package:epicture/image_model.dart';
import 'package:epicture/imgur_api.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';

class ExplorationPage extends StatefulWidget {
  final ImgurApi api;

  ExplorationPage(this.api);

  @override
  State<StatefulWidget> createState() => _ExplorationPageState();
}

class _ExplorationPageState extends State<ExplorationPage> {
  List<ImageModel> images = [];

  _loadExplore() async {
    images = await widget.api.getExplore();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadExplore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: draw(context, widget.api),
      body: ImageList(
        images: images,
        showFavorite: false,
        dispSearch: false,
        api: widget.api,
        title: "Explore",
      ),
    );
  }
}
