import 'package:flutter/material.dart';

import 'package:covid19/source/moc.data.dart';

class Recover extends StatefulWidget {
  String dataForCountry;
  Recover(this.dataForCountry, {Key? key}) : super(key: key);

  @override
  _RecoverState createState() => _RecoverState(dataForCountry);
}

class _RecoverState extends State<Recover> {
  String dataForCountry;
  _RecoverState(this.dataForCountry);

  @override
  Widget build(BuildContext context) {
    var dataOnPage = (MocData.historicData.firstWhere(
      (element) => element["country"] == dataForCountry,
    ))["timeline"]["recovered"];

    return Center(
      child: Text("Recovered" + dataOnPage.toString()),
    );
  }
}
