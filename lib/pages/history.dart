import 'dart:html';

import 'package:covid19/source/data.source.dart';
import 'package:covid19/source/moc.data.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

/// Task
/// 1.Oninit()
/// 1.a Make API call https://disease.sh/v3/covid-19/historical?lastdays=30 and show data --> using moc data
/// 1.b Let the user select the required country
/// 2. Let user select number of days thatis to includeed in history

class _HistoryState extends State<History> {
  late List<Map<String, dynamic>> historydata;
  @override
  void initState() {
    historydata = MocData.historicData;
    super.initState();
  }

  var dataForCountry = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History data"),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: DropdownSearch<String>(
              mode: Mode.MENU,
              showSearchBox: true,
              items: DataSource.countryList,
              popupItemDisabled: (String s) => s.startsWith('I'),
              onChanged: (selectedItem) {
                setState(() {
                  dataForCountry = selectedItem!;
                });
              },
              selectedItem: "Select country",
            ),
          ),
          if (dataForCountry == "")
            Text("Empty: " + dataForCountry)
          else
            Text("Country: " + dataForCountry)
        ],
      ),
    );
  }
}
