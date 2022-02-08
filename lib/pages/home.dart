import 'package:flutter/material.dart';

import '../source/data.source.dart';
import '../source/moc.data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/// Task
/// 1. Display advisory banner
/// 2. Manipulation of Horizontal Scrolling List
///   2.a Show world data - https://disease.sh/v3/covid-19/all - Done (Yet to implimented API call)
///   2.c Show only selected fields from API responce - Done
///   2.d Let the user add the required fields to the horizontal scroll - (Yet to give UI to pic fields)
/// 3. Have a refresh icon above the top 10 list to refresh data in it
/// 4. Show top 10 Country Data  - https://disease.sh/v3/covid-19/countries?sort=cases
///   4.a Let user pick ( cases, todayCases, deaths, recovered, active )
///   4.c When the user picks the sort criteria don't make API call, sort the local data - use below snippet
///       top10Countries.sort((a, b) => (b["countryInfo"]["_id"]).compareTo(a["countryInfo"]["_id"]));
///
class _HomePageState extends State<HomePage> {
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
  var dataToShowHorizontalList = ["cases", "deaths", "recovered", "active"];
  var sortCountryListBy = 'cases';
  Widget getHorizontalCard(
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
              dataAttribute[0].toUpperCase() +
                  dataAttribute.substring(1).toLowerCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

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
          // Horizontal scrolling List for task 2
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dataToShowHorizontalList.length,
                separatorBuilder: (context, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  int cardindex = (index > cardColors.length - 1)
                      ? index % cardColors.length
                      : index;
                  return getHorizontalCard(
                      cardColor: cardColors[cardindex],
                      dataAttribute: dataToShowHorizontalList[index],
                      dataValue:
                          MocData.worldData[dataToShowHorizontalList[index]]);
                },
              ),
            ),
          ),
          // Show:
          // Text   = "Top 10 countries"
          // Button = Refresh
          // Button = Sort
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Top 10 countries",
                  style: TextStyle(
                    color: Color.fromARGB(255, 61, 58, 58),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Please wait while refresing"),
                          action: SnackBarAction(
                            label: "OK",
                            onPressed: () {},
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.refresh_outlined,
                        color: Color.fromARGB(255, 61, 58, 58),
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Text("Sort by:"),
                            children: <Widget>[
                              ListTile(
                                  title: const Text("Total cases"),
                                  onTap: () =>
                                      Navigator.pop(context, "Total cases")),
                              ListTile(
                                  title: const Text("Total Deths"),
                                  onTap: () =>
                                      Navigator.pop(context, "Deaths")),
                              ListTile(
                                  title: const Text("Active cases"),
                                  onTap: () =>
                                      Navigator.pop(context, "Active cases")),
                            ],
                          ),
                        ).then(
                          (selectedOption) {
                            if (selectedOption != null) {
                              setState(
                                  () => sortCountryListBy = selectedOption);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("you have clicked $selectedOption"),
                                  action: SnackBarAction(
                                    label: "OK",
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.sort,
                            color: Color.fromARGB(255, 61, 58, 58),
                            size: 30.0,
                          ),
                          Text(
                            sortCountryListBy,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 61, 58, 58),
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Top 10 countries ListView
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => top10CountriesCard(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget top10CountriesCard(int index) {
    return ListTile(
      leading: Card(
        elevation: 25,
        child: Image.network(
          MocData.top10Countries[index]["countryInfo"]["flag"],
          height: 50,
          width: 60,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, progress) {
            return progress == null
                ? child
                : const CircularProgressIndicator.adaptive();
          },
          semanticLabel: 'Flag of ${MocData.top10Countries[index]["country"]}',
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('COUNTRY : ${MocData.top10Countries[index]["country"]}'),
          Text('CASES        : ${MocData.top10Countries[index]["cases"]}'),
          Text('DEATHS      : ${MocData.top10Countries[index]["deaths"]}'),
          Text('ACTIVE CASES : ${MocData.top10Countries[index]["active"]}'),
        ],
      ),
      trailing: Column(
        children: [
          Text(MocData.top10Countries[index]["countryInfo"]["iso3"]),
          const Icon(
            Icons.arrow_forward,
            color: Color.fromARGB(255, 61, 58, 58),
            size: 30.0,
          ),
        ],
      ),
    );
  }

  Widget xtop10CountriesCard(int index) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            /// Column:
            /// 1. Flag
            /// 2. Country code
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.05,
                      ),
                    ),
                    child: Image.network(
                      MocData.top10Countries[index]["countryInfo"]["flag"],
                      height: 50,
                      width: 70,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, progress) {
                        return progress == null
                            ? child
                            : const CircularProgressIndicator.adaptive();
                      },
                      semanticLabel:
                          'Flag of ${MocData.top10Countries[index]["country"]}',
                    ),
                  ),
                  Text(MocData.top10Countries[index]["countryInfo"]["iso3"]),
                ],
              ),
            ),

            /// Column:
            /// Country data
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('COUNTRY : ${MocData.top10Countries[index]["country"]}'),
                  Text(
                      'CASES        : ${MocData.top10Countries[index]["cases"]}'),
                  Text(
                      'DEATHS      : ${MocData.top10Countries[index]["deaths"]}'),
                  Text(
                      'ACTIVE CASES : ${MocData.top10Countries[index]["active"]}'),
                ],
              ),
            ),

            /// Column:
            /// Show more data icon
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: const [
            // Icon(
            //   Icons.refresh_outlined,
            //   color: Color.fromARGB(255, 61, 58, 58),
            //   size: 30.0,
            // ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
