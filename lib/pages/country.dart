import 'package:flutter/material.dart';

class Country extends StatefulWidget {
  Map<String, dynamic> countryData;

  Country({Key? key, required this.countryData}) : super(key: key);
  @override
  _CountryState createState() => _CountryState(countryData);
}

/// Based on the data(bool) in countryData["showCountryPick"], decide wether to show country picking option
class _CountryState extends State<Country> {
  Map<String, dynamic> countryData;
  _CountryState(this.countryData);

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
            child: Text("Showing country picker"),
          ),
          Visibility(
            visible: !countryData["showCountryPick"],
            child: Text(countryData.toString()),
          )
        ],
      ),
    );
  }
}
