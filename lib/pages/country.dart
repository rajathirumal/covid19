import 'package:covid19/source/moc.data.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';

import '../source/data.source.dart';

class Country extends StatefulWidget {
  Map<String, dynamic> countryData;

  Country({Key? key, required this.countryData}) : super(key: key);
  @override
  _CountryState createState() => _CountryState(countryData);
}

/// Task
/// Based on the data(bool) in countryData["showCountryPick"], decide wether to show country picking option - done
class _CountryState extends State<Country> {
  Map<String, dynamic> countryData;

  _CountryState(this.countryData);

  final Map<String, dynamic> _whatToShow = {
    "active": {
      "icon": Icons.local_hospital,
      "text": "Active cases",
      "also": {"show": "critical", "text": "Critical Cases"}
    },
    "cases": {
      "icon": Icons.people_outline_rounded,
      "text": "Total cases",
      "also": {"show": "todayCases", "text": "New Cases"}
    },
    "deaths": {
      "icon": Icons.personal_injury,
      "text": "Total Deths",
      "also": {"show": "todayDeaths", "text": "New deaths"}
    },
    "casesPerOneMillion": {
      "icon": Icons.data_exploration,
      "text": "Case/Million",
      "also": {"show": "deathsPerOneMillion", "text": "Deaths/Million"}
    },
    "recovered": {
      "icon": Icons.replay,
      "text": "Total Recovered",
      "also": {"show": "todayRecovered", "text": "New recovery"}
    },
    "tests": {
      "icon": Icons.biotech,
      "text": "Total tests",
      "also": {"show": "testsPerOneMillion", "text": "Test/Million"}
    },
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country data"),
      ),
      body: Column(
        children: [
          Visibility(
            visible: countryData["showCountryPick"],
            child: // Text("Showing country picker"),
                Column(
              children: <Widget>[
                Form(
                  child: Column(
                    children: [
                      //  create a drop down wit _countries data
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSearchBox: true,
                          items: DataSource.countryList,
                          popupItemDisabled: (String s) => s.startsWith('I'),
                          onChanged: (selectedCountry) {
                            setState(() {
                              countryData = MocData.top10Countries.firstWhere(
                                (e) => e['country'] == selectedCountry,
                                orElse: () => {},
                              );
                              countryData["showCountryPick"] = false;
                            });
                          },
                          selectedItem: "Select country",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // when you come from home
          // Expanded(
          //   child:
          if (!countryData["showCountryPick"])
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Card(
                        shadowColor: Colors.red,
                        elevation: 300,
                        child: Image.network(
                          countryData["countryInfo"]["flag"] ?? '',
                          errorBuilder: (context, obj, stackTrace) {
                            return const Icon(Icons.broken_image_outlined);
                          },
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : const CircularProgressIndicator.adaptive();
                          },
                          semanticLabel: 'Flag of ${countryData["country"]}',
                        ),
                      ),
                      Text(
                        countryData["country"] +
                            ' (' +
                            countryData["continent"] +
                            ')',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  ListView.builder(
                      primary: false,
                      itemCount: _whatToShow.keys.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          countryDetailTile(index)),
                ],
              ),
            ),
          // ),
        ],
      ),
    );
  }

  Widget countryDetailTile(index) {
    String whatToshowKey = _whatToShow.keys.elementAt(index);
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              _whatToShow[whatToshowKey]["icon"],
              color: Colors.redAccent[100],
              size: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    countryData[whatToshowKey].toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    (_whatToShow[whatToshowKey]["text"]),
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    countryData[_whatToShow[whatToshowKey]["also"]["show"]]
                        .toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    _whatToShow[whatToshowKey]["also"]["text"].toString(),
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
