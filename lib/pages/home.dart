import 'dart:ui';

import 'package:flutter/material.dart';

import '../source/data.source.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/// Task
///  1. Display advisory banner
/// 2.A Show world data - https://disease.sh/v3/covid-19/all
/// TODO : 2.B Show only selected fields from API responce
/// TODO: 3. Show top 5 Country Data - Let user pick ( cases, todayCases, deaths, recovered, active ) - https://disease.sh/v3/covid-19/countries?sort=deaths
///
class _HomePageState extends State<HomePage> {
  Map<String, dynamic> mocData = {
    "updated": 1644142080461,
    "cases": 394491104,
    "todayCases": 576450,
    "deaths": 5753983,
    "todayDeaths": 2109,
    "recovered": 313286867,
    "todayRecovered": 530096,
    "active": 75450254,
    "critical": 91285,
    "casesPerOneMillion": 50610,
    "deathsPerOneMillion": 738.2,
    "tests": 5188386532,
    "testsPerOneMillion": 658443.04,
    "population": 7879780341,
    "oneCasePerPeople": 0,
    "oneDeathPerPeople": 0,
    "oneTestPerPeople": 0,
    "activePerOneMillion": 9575.17,
    "recoveredPerOneMillion": 39758.32,
    "criticalPerOneMillion": 11.58,
    "affectedCountries": 225
  };
  Widget getCard(
          {required cardColor,
          required var dataValue,
          required String dataAttribute}) =>
      Container(
        width: 200,
        padding: const EdgeInsets.all(10.0),
        color: cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                dataValue.toString(),
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              dataAttribute,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
  var cardColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.pink,
    Colors.amber,
    Colors.deepPurple,
    Colors.grey,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Advisory // Task 1
          Container(
            height: 120,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            color: Colors.orange[100],
            child: Text(
              DataSource.quote,
              style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          // Horizontal List for task 2
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mocData.length,
                separatorBuilder: (context, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  int cardindex = (index > cardColors.length - 1)
                      ? index % cardColors.length
                      : index;
                  return getCard(
                      cardColor: cardColors[cardindex],
                      dataAttribute: mocData.keys.elementAt(index),
                      dataValue: mocData.values.elementAt(index));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
