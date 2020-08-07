import 'dart:convert';

import 'package:etkinlik_yonetim_sistemi_mobil/ApplicationsPage.dart';
import 'package:etkinlik_yonetim_sistemi_mobil/EventCard.dart';
import 'package:etkinlik_yonetim_sistemi_mobil/QRScanPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home ssPage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _rawData = new List();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  fetch() async {
    final response = await http.get('http://10.0.2.2:8080/getFutureEvents');
    setState(() {
      _rawData = json.decode(utf8.decode(response.bodyBytes));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.border_clear),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QRScanPage(
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => fetch(),
            icon: Icon(Icons.refresh),
          ),
          FlatButton(
            child: Text("Başvurularım"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApplicationsPage(
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: _rawData.length,
          itemBuilder: (BuildContext ctxt, int index) {
        return EventCard(json: _rawData[index]);
      }),
    );
  }
}
