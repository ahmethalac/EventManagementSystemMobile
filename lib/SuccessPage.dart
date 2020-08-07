import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SuccessPage extends StatefulWidget {
  final String uuid;
  final Map<String, dynamic> json;

  SuccessPage({this.uuid, this.json});

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  Completer<GoogleMapController> _controller = Completer();
  double lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lat = double.parse(widget.json["lat"].toString());
    lng = double.parse(widget.json["lng"].toString());
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Başvurunuz Onaylandı",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GoogleMap(
            markers: [
              Marker(
                markerId: MarkerId("eventLocation"),
                position: LatLng(lat, lng),
              )
            ].toSet(),
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 15.0,
            ),
            onMapCreated: _onMapCreated,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "Etkinlik günü bu QR Kod ile giriş yapabilirsiniz",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: QrImage(
              data: widget.uuid,
            ),
          ),
        ),
      ],
    );
  }
}
