import 'dart:convert';

import 'package:etkinlik_yonetim_sistemi_mobil/SuccessPage.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplyPage extends StatefulWidget {
  final Map<String, dynamic> json;

  ApplyPage({this.json});

  @override
  _ApplyPageState createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool success = false;
  String uuid;
  String name;
  String email;
  String tcKimlikNo;
  List<Map<String, String>> extraFields = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (widget.json['extraFields'] as List).forEach((element) {
      extraFields.add(<String, String>{'question': element, 'answer': ""});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Center(
            child: AutoSizeText(
              widget.json["name"] + " Başvuru",
              style: TextStyle(),
              maxLines: 2,
              textAlign: TextAlign.center,
            )),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Container(
          color: Colors.white,
          child: success ? SuccessPage(uuid: uuid, json: widget.json) : buildForm(),
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                decoration: InputDecoration(hintText: "İsim soyisim"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "İsim soyisim boş olamaz";
                  }
                  return null;
                },
                onChanged: (value) => this.setState(() {
                  name = value;
                }),
                autofocus: mounted,
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                decoration: InputDecoration(hintText: "Email"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Email boş olamaz";
                  }
                  return null;
                },
                onChanged: (value) => this.setState(() {
                  email = value;
                }),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                decoration: InputDecoration(hintText: "TC Kimlik No"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "TC Kimlik No boş olamaz";
                  }
                  return null;
                },
                onChanged: (value) => this.setState(() {
                  tcKimlikNo = value;
                }),
                keyboardType: TextInputType.number,
              ),
            ),
            ...(extraFields.map((e) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(hintText: e["question"]),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Bu alan boş olamaz";
                    }
                    return null;
                  },
                  onChanged: (value) => this.setState(() {
                    e["answer"] = value;
                  }),
                  keyboardType: TextInputType.text,
                ),
              );
            })),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    submit();
                  }
                },
                child: Text("Kaydol"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() async {
    final response = await http.post(
      'http://10.0.2.2:8080/applyEvent/' + widget.json["uuid"],
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, Object>{
        'nameSurname': name,
        'tcKimlikNo': tcKimlikNo,
        'email': email,
        'answers': extraFields
      }),
    );
    if (response.statusCode == 200) {
      saveToLocalStorage();
      setState(() {
        uuid = response.body;
        success = true;
      });
    }
    else if (response.body == "quota"){
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Kontenjan yetersiz!"),
      ));
    }
    else{
      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text((data["errors"] as List).elementAt(0)["defaultMessage"]),
      ));
    }
  }

  void saveToLocalStorage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> applications = preferences.getStringList("uuids") ?? new List();
    applications.add(uuid);
    await preferences.setStringList("uuids", applications);
  }
}
