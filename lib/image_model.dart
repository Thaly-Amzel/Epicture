import 'package:flutter/material.dart';

class ImageModel {
  final String url;

  ImageModel(this.url);

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(json['link']);
  }
}
