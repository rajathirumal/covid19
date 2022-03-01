import 'package:covid19/source/data.source.dart';
import 'package:covid19/source/moc.data.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:syncfusion_officechart/officechart.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

/// Task
/// 1.Oninit()
///   1.a Make API call https://disease.sh/v3/covid-19/historical?lastdays=30 and show data --> using moc data
///   1.b Let the user select the required country
/// 2.Use bottm navigation bar - Cases, Deths, Recovery 
///   2.a Based on the choice of nav item show page
///   2.b In the page let the user select number of days to show data for. And then show chart
///

class _HistoryState extends State<History> {
  late List<Map<String, dynamic>> historydata;
  @override
  void initState() {
    historydata = MocData.historicData;
    super.initState();
  }

  var dataForCountry = "";
  int currentBottonNavItem = 0;

  var screens = [
    Center(
      child: Text("Cases"),
    ),
    Center(
      child: Text("Death"),
    ),
    Center(
      child: Text("Recovered"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History data"),
      ),
      body: dataForCountry == ""
          ? Visibility(
              visible: dataForCountry == "",
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSearchBox: true,
                  items: DataSource.countryList,
                  onChanged: (selectedItem) {
                    setState(() {
                      dataForCountry = selectedItem!;
                    });
                  },
                  selectedItem: "Select country",
                ),
              ),
            )
          : screens[currentBottonNavItem],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        currentIndex: currentBottonNavItem,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.yellow,
        onTap: (index) {
          if (dataForCountry != "") {
            setState(() {
              var res = (MocData.historicData.firstWhere(
                (element) => element["country"] == dataForCountry,
              ))["timeline"];
              currentBottonNavItem = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            label: "Cases",
            backgroundColor: Colors.redAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.personal_injury),
            label: "Deaths",
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.celebration),
            label: "Recovered",
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
