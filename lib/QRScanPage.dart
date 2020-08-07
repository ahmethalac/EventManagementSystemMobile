import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  bool scanned = false;
  bool fail = true;
  Map<String, dynamic> rawData = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              fail = true;
              searchApplicant();
            },
            child: Text("QR Kod Oku"),
          ),
        ],
      ),
      body: Center(
        child: scanned
            ? Container(
                height: 100,
                child: fail
                    ? Text("Böyle bir katılımcı bulunmamaktadır")
                    : Column(
                        children: [
                          Text(
                            "Katılımcı doğrulandı",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Etkinlik Adı: " + rawData["name"],
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Tarih: " + dateFormat(rawData["startDate"], rawData["endDate"]),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
              )
            : Container(),
      ),
    );
  }

  searchApplicant() async {
    var uuid = await scanner.scan();
    var response = await http.get("http://10.0.2.2:8080/getEventFromApplicant/" + uuid);
    setState(() {
      scanned = true;
    });
    if (response.body != "") {
      setState(() {
        fail = false;
        rawData = json.decode(utf8.decode(response.bodyBytes));
      });
      http.get("http://10.0.2.2:8080/setAttendedProperty/" + uuid + "/true");
    }
  }

  String dateFormat(rawStartDate, rawEndDate) {
    if (DateTime.parse(rawStartDate)
        .compareTo(DateTime.parse(rawEndDate)) !=
        0) {
      return DateFormat("d MMMM yyyy")
          .format(DateTime.parse(rawStartDate)) +
          " - " +
          DateFormat("d MMMM yyyy").format(DateTime.parse(rawEndDate));
    }
    return DateFormat("d MMMM yyyy").format(DateTime.parse(rawStartDate));
  }
}
