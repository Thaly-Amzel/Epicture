import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    return;
  }
}

