import 'dart:convert';

import 'package:etkinlik_yonetim_sistemi_mobil/ApplicantCard.dart';
import 'package:etkinlik_yonetim_sistemi_mobil/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApplicationsPage extends StatefulWidget {
  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  List<dynamic> rawData = new List();
  List<String> uuids = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Başvurulan Etkinlikler",
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            onPressed: () => reset(),
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: rawData.length,
            itemBuilder: (BuildContext context, int index) {
              return ApplicantCard(
                json: rawData[index],
                uuid: uuids[index]
              );
            }),
      ),
    );
  }

  void fetch() async {
    print("fetching");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> fetchedUuids = preferences.getStringList("uuids");
    if (fetchedUuids != null) {
      fetchedUuids.forEach((element) {
        getEvent(element);
      });
    }
    setState(() {
      uuids = fetchedUuids ?? new List();
    });
  }

  void getEvent(String element) async {
    var response = await http.get("http://10.0.2.2:8080/getEventFromApplicant/" + element);
    var temp = rawData;
    temp.add(json.decode(utf8.decode(response.bodyBytes)));
    setState(() {
      rawData = temp;
    });
  }

  reset() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    setState(() {
      uuids = new List();
      rawData = new List();
    });
  }
}
