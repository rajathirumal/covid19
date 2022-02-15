import 'package:flutter/material.dart';

class Country extends StatefulWidget {
  Map<String, dynamic> countryData;

  Country({Key? key, required this.countryData}) : super(key: key);
  @override
  _CountryState createState() => _CountryState(countryData);
}

class _CountryState extends State<Country> {
  Map<String, dynamic> countryData;
  _CountryState(this.countryData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country data"),
      ),
      body: Text(countryData.toString()),
    );
  }
}
