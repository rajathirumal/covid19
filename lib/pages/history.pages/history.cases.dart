import 'package:flutter/material.dart';

import 'package:covid19/source/moc.data.dart';

class Cases extends StatefulWidget {
  String dataForCountry;
  Cases(this.dataForCountry, {Key? key}) : super(key: key);

  @override
  _CasesState createState() => _CasesState(dataForCountry);
}

class _CasesState extends State<Cases> {
  String dataForCountry;
  _CasesState(this.dataForCountry);
  @override
  Widget build(BuildContext context) {
    var dataOnPage = (MocData.historicData.firstWhere(
      (element) => element["country"] == dataForCountry,
    ))["timeline"]["cases"];
    return Center(
      child: Text("Cases" + dataOnPage.toString()),
    );
  }
}
