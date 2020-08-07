import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ApplicantCard extends StatefulWidget {
  final Map<String, dynamic> json;
  final String uuid;

  ApplicantCard({this.json, this.uuid});

  @override
  _ApplicantCardState createState() => _ApplicantCardState();
}

class _ApplicantCardState extends State<ApplicantCard> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng coordinates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coordinates = LatLng(double.parse(widget.json["lat"].toString()), double.parse(widget.json["lng"].toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          widget.json["name"],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          maxLines: 2,
                        ),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        Text(dateFormat()),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(),
                          body: Center(
                            child: QrImage(
                              data: widget.uuid,
                              size: 300,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: QrImage(
                    padding: EdgeInsets.only(top: 8, right: 5),
                    data: widget.uuid,
                    size: 100,
                  ),
                )
              ],
            ),
            Container(
                padding: EdgeInsets.all(5),
                height: 100,
                child: GoogleMap(
                  markers: [
                    Marker(
                      markerId: MarkerId("eventLocation"),
                      position: coordinates,
                    )
                  ].toSet(),
                  initialCameraPosition: CameraPosition(target: coordinates, zoom: 14),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ))
          ],
        ),
      ),
    );
  }

  String dateFormat() {
    if (DateTime.parse(widget.json["startDate"]).compareTo(DateTime.parse(widget.json["endDate"])) != 0) {
      return DateFormat("d MMMM yyyy").format(DateTime.parse(widget.json["startDate"])) +
          " - " +
          DateFormat("d MMMM yyyy").format(DateTime.parse(widget.json["endDate"]));
    }
    return DateFormat("d MMMM yyyy").format(DateTime.parse(widget.json["startDate"]));
  }
}
