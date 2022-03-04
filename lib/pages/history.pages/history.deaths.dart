import 'package:flutter/material.dart';
import 'package:covid19/source/moc.data.dart';

class Deaths extends StatefulWidget {
  String dataForCountry;
  Deaths(this.dataForCountry, {Key? key}) : super(key: key);

  @override
  _DeathsState createState() => _DeathsState(dataForCountry);
}

class _DeathsState extends State<Deaths> {
  String dataForCountry;
  _DeathsState(this.dataForCountry);
  @override
  Widget build(BuildContext context) {
    var dataOnPage = (MocData.historicData.firstWhere(
      (element) => element["country"] == dataForCountry,
    ))["timeline"]["deaths"];
    return Center(
      child: Text("Deaths" + dataOnPage.toString()),
    );
  }
}
