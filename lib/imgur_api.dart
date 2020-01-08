import 'dart:convert';
import 'dart:io';
import 'package:epicture/image_model.dart';
import 'package:http/http.dart' as http;

class ImgurApi {
  static final String clientId = "e242990a24b2af4";
  static final String secretId = "a9435babeca95cedc7c8d9c7c0edc969b88b5ab2";

  static final String authorizationEndpoint =
      "https://api.imgur.com/oauth2/authorize";
  final String _tokenEndpoint = "https://api.imgur.com/oauth2/token";

  final HttpClient _client = HttpClient();

  String _token;

  String userName;

  Future<String> getToken(String pin) async {
    if (_token != null) return _token;
    _token = await _getToken('grant_type=pin&'
        'client_id=$clientId&'
        'client_secret=$secretId&'
        'pin=$pin');
    return _token;
  }

  Future<String> _getToken(String formData) async {
    var req = await _client.postUrl(Uri.parse(_tokenEndpoint));
    req
      ..headers.contentType =
          ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8')
      ..write(formData);

    var resp = await req.close();

    var data = await _parseData(resp);

    userName = data['account_username'];
    return data['access_token'];
  }

  Future<Map<dynamic, dynamic>> _parseData(HttpClientResponse response) async {
    if (response.statusCode == HttpStatus.notFound) {
      throw 'User does not exist';
    }
    if (response.statusCode >= 400) {
      print(response.reasonPhrase);
      Map error = jsonDecode(jsonEncode(await _extractJsonObject(response)));
      var errorMsg = error.toString();
      throw '$errorMsg';
    }
    return jsonDecode(jsonEncode(await _extractJsonObject(response)));
  }

  Future<Object> _extractJsonObject(HttpClientResponse response) =>
      response.transform(utf8.decoder).transform(json.decoder).first;

  Future<List<ImageModel>> fetchMyImages() async {
    var response = await http.get("https://api.imgur.com/3/account/me/images",
        headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var imageList = List<ImageModel>();
      json['data'].forEach((image) {
        imageList.add(ImageModel.fromJson(image));
      });
      return imageList;
    } else {
      throw 'Could not retrieve images';
    }
  }

  Future<List<ImageModel>> getFavorite() async {
    var uri = Uri.parse(
        "https://api.imgur.com/3/account/$userName/gallery_favorites/");
    var response = await http.get(uri,
        headers: {HttpHeaders.authorizationHeader: "Client-ID $clientId"});
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var imageList = List<ImageModel>();
      json['data'].forEach((image) {
        image['images'].forEach((elem) {
          if (elem['type'].toString().contains("image"))
            imageList.add(ImageModel(elem['link']));
        });
      });
      return imageList;
    } else {
      throw "Could not load favorite ...";
    }
  }

  Future<List<ImageModel>> getExplore() async {
    var uri = Uri.parse("https://api.imgur.com/3/gallery/hot");
    var response = await http.get(uri,
        headers: {HttpHeaders.authorizationHeader: "Client-ID $clientId"});
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var imageList = List<ImageModel>();
      json['data'].forEach((data) {
        if (data['images'] != null) {
          data['images'].forEach((image) {
            if (image['link'] != null && image['type'].toString().contains("image"))
              imageList.add(ImageModel(image['link']));
          });
        }
      });
      return imageList;
    } else {
      throw "Could not load explore";
    }
  }
}
