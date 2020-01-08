import 'package:epicture/imgur_api.dart';
import 'package:epicture/page_home.dart';
import 'package:epicture/image_model.dart';
import 'package:flutter/material.dart';
import 'package:epicture/url_launch.dart';
import 'package:epicture/imgur_widget.dart';

class ImageList extends StatefulWidget {
  final List<ImageModel> images;
  final String title;
  final bool dispSearch;
  final ImgurApi api;
  final bool showFavorite;

  ImageList({
    @required this.images,
    @required this.title,
    @required this.dispSearch,
    @required this.api,
    @required this.showFavorite,
  });

  @override
  State<StatefulWidget> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final TextEditingController _filter = TextEditingController();
  String _searchTxt = "";
  List<ImageModel> _filteredList = List();
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle;

  @override
  void initState() {
    super.initState();
    _filteredList = widget.images;
    _appBarTitle = Text(widget.title);
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  Widget _buildList(int itemCount) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        if (!widget.dispSearch || _searchTxt.isEmpty) {
          return ImgurImgWidget(
            widget.api,
            widget.images[index],
            widget.showFavorite,
          );
        } else {
          return ImgurImgWidget(
            widget.api,
            _filteredList[index],
            widget.showFavorite,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var itemCount;
    if (widget.dispSearch && _searchTxt.isNotEmpty) {
      itemCount = _filteredList == null ? 0 : _filteredList.length;
    } else {
      itemCount = widget.images == null ? 0 : widget.images.length;
    }

    List<Widget> widgetList = [_buildList(itemCount)];

    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: _appBarTitle,
            leading: widget.dispSearch
                ? IconButton(
                    icon: _searchIcon,
                    onPressed: _searchPressed,
                  )
                : Container(),
            automaticallyImplyLeading: false,
            floating: true,
           // backgroundColor: MyColors.frame,
            pinned: widget.dispSearch,
          ),
          SliverList(
              delegate: SliverChildListDelegate(
            <Widget>[Column(children: widgetList)],
          )),
        ],
      ),
    );
  }

  _searchInGallery() async {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchTxt = "";
        _filteredList = widget.images;
      });
    } else {
      _searchTxt = _filter.text;
      //_filteredList = await widget.api.searchGallery(_searchTxt);
      setState(() {});
    }
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = Icon(Icons.close);
        _appBarTitle = TextField(
          style: TextStyle(color: Colors.white),
          controller: _filter,
          autofocus: true,
          onSubmitted: (String value) {
            _searchTxt = value;
            _searchInGallery();
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchInGallery,
            ),
            border: InputBorder.none,
            hintText: "Search...",
          ),
        );
      } else {
        _searchIcon = Icon(Icons.search);
        _appBarTitle = Text(widget.title);
        _filteredList = widget.images;
        _searchTxt = "";
        _filter.clear();
      }
    });
  }
}
