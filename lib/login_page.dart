import 'package:epicture/field_validator.dart';
import 'package:epicture/imgur_api.dart';
import 'package:epicture/page_home.dart';
//import 'package:epicture/photo_page.dart';
import 'package:flutter/material.dart';
import 'package:epicture/url_launch.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ImgurApi api = ImgurApi();
  final _troll = GlobalKey<FormState>();
  String _pinInput;

  validateForm() {
    final form = _troll.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  validateAndSubmit() async {
    if (validateForm()) {
      try {
        await api.getToken(_pinInput);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePage(api)));
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(60.0),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Image.asset('assets/images.jpeg'),
              ),
              Form(
                key: _troll,
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Put PIN here",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                  validator: FieldValidator.validatePin,
                  onSaved: (val) => _pinInput = val,
                ),
              ),
              SizedBox(height: 40),
              RaisedButton(
                child: Text(
                  "Get PIN",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () async {
                  await launchUrl(
                      "${ImgurApi.authorizationEndpoint}?client_id=${ImgurApi.clientId}&response_type=pin");
                },
              ),
              RaisedButton(
                child: Text(
                  'Connexion',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () => validateAndSubmit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
