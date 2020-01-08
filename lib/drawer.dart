import 'package:epicture/image_model.dart';
import 'package:epicture/imgur_api.dart';
import 'package:epicture/page_home.dart';
import 'package:flutter/material.dart';
import 'package:epicture/exploration.dart';
import 'package:epicture/favorite_page.dart';

Widget draw(BuildContext context, ImgurApi api) {
 return Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(child: Text (api.userName)),
            ListTile(
              title: Text("Images"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>HomePage(api)));
              },
            ),
            ListTile(
              title: Text("Favorite"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>FavoritePage(api)));
              },
            ),
            ListTile(
              title: Text("Exploration"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ExplorationPage(api)));
              },
            )
          ],
        ),
      );
}