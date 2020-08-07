import 'package:auto_size_text/auto_size_text.dart';
import 'package:etkinlik_yonetim_sistemi_mobil/ApplyPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> json;

  EventCard({this.json});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      json["name"],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      maxLines: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                    ),
                    Text(dateFormat(json["startDate"],json["endDate"])),
                  ],
                ),
              ),
              IconButton(
                onPressed: int.parse(json["applicantCount"].toString()) >=
                        int.parse(json["quota"].toString())
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplyPage(
                              json: json,
                            ),
                          ),
                        );
                      },
                icon: Icon(Icons.person_add),
              ),
            ],
          ),
        ),
      ),
    );
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
