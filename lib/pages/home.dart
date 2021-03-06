import 'package:covid19/helper/extensions.dart';
import 'package:covid19/pages/country.dart';
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
///   2.d Let the user add the required fields to the horizontal scroll - (UI designed, not implimeted yet)
/// 3. Have a refresh icon above the top 10 list to refresh data in it - (UI designed, not implimented API call)
/// 4. Show top 10 Country Data  - https://disease.sh/v3/covid-19/countries?sort=cases
///   4.a Let user pick either of cases, todayCases, deaths, recovered, active - (UI done, yet to impliment functionality)
///   4.c When the user picks the sort criteria don't make API call, sort the local data - use below snippet
///       top10Countries.sort((a, b) => (b["countryInfo"]["_id"]).compareTo(a["countryInfo"]["_id"])); - done
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
  Map<String, bool?> checkBoxValue = {
    "cases": true,
    "deaths": true,
    "recovered": true,
    "active": true,
    "population": false,
    "tests": false,
  };
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
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 31, 19, 19)),
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
    print(dataToShowHorizontalList);
    List<Map<String, dynamic>> myData = MocData.top10Countries;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          // Show:
          // Text   = "All over the world"
          // Button = Add
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 5, bottom: 0, right: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All over the world",
                  style: TextStyle(
                    color: Color.fromARGB(255, 61, 58, 58),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () async => {
                    await showFielSelection(context),
                  },
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 61, 58, 58),
                    size: 35.0,
                  ),
                ),
              ],
            ),
          ),
          // Horizontal scrolling List for task 2
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 150,
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
                      onTap: () {
                        setState(() {
                          sortCountryListBy = 'cases';
                          myData.sort((a, b) => (b[sortCountryListBy])
                              .compareTo(a[sortCountryListBy]));
                        });
                      },
                      child: const Icon(
                        Icons.refresh_outlined,
                        color: Color.fromARGB(255, 61, 58, 58),
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Text("Sort by:"),
                            children: <Widget>[
                              ListTile(
                                  title: const Text("Total cases"),
                                  onTap: () => Navigator.pop(context, "cases")),
                              ListTile(
                                  title: const Text("Total Deths"),
                                  onTap: () =>
                                      Navigator.pop(context, "deaths")),
                              ListTile(
                                  title: const Text("Active cases"),
                                  onTap: () =>
                                      Navigator.pop(context, "active")),
                            ],
                          ),
                        ).then(
                          (selectedOption) {
                            if (selectedOption != null) {
                              setState(
                                () {
                                  sortCountryListBy = selectedOption;

                                  myData.sort((a, b) => (b[selectedOption])
                                      .compareTo(a[selectedOption]));
                                },
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
                            sortCountryListBy.extensionCapitalize(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 61, 58, 58),
                              fontSize: 15,
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
          // Shows 10 data form `myData`
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) =>
                  top10CountriesCard(index, myData),
            ),
          ),
        ],
      ),
    );
  }

  Widget top10CountriesCard(int index, List<Map<String, dynamic>> countryData) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: ListTile(
        onTap: () {
          // Call a new Country Page with -> countryData[index]
          // If call is from home.dart, show country details with the details passed from this
          // Else If call is from drawer.dart, show option for the user to select country name
        },
        leading: Card(
          elevation: 25,
          child: Image.network(
            countryData[index]["countryInfo"]["flag"] ?? '',
            height: 40,
            width: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, obj, stackTrace) {
              return const Icon(Icons.broken_image_outlined);
            },
            loadingBuilder: (context, child, progress) {
              return progress == null
                  ? child
                  : const CircularProgressIndicator.adaptive();
            },
            semanticLabel: 'Flag of ${countryData[index]["country"]}',
          ),
        ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('COUNTRY'),
                Text('CASES '),
                Text('DEATHS '),
                Text('ACTIVE CASES'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(': ${countryData[index]["country"]}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(': ${countryData[index]["cases"]}'),
                Text(': ${countryData[index]["deaths"]}'),
                Text(': ${countryData[index]["active"]}'),
              ],
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: () {
            //call Country(countryData[index])
            countryData[index]["showCountryPick"] = false;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Country(countryData: countryData[index]),
              ),
            );
            // print(countryData[index]["from"] = 'home.dart');
          },
          child: Column(
            children: [
              const Icon(
                Icons.arrow_forward,
                color: Color.fromARGB(255, 61, 58, 58),
                size: 30.0,
              ),
              Text(
                countryData[index]["countryInfo"]["iso3"],
                style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showFielSelection(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title:
                      Text(dataToShowHorizontalList[0].extensionCapitalize()),
                  value: checkBoxValue["cases"],
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title:
                      Text(dataToShowHorizontalList[1].extensionCapitalize()),
                  onChanged: (value) {},
                  value: checkBoxValue[dataToShowHorizontalList[1]],
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title:
                      Text(dataToShowHorizontalList[2].extensionCapitalize()),
                  onChanged: (value) {},
                  value: checkBoxValue[dataToShowHorizontalList[2]],
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title:
                      Text(dataToShowHorizontalList[3].extensionCapitalize()),
                  onChanged: (value) {},
                  value: checkBoxValue[dataToShowHorizontalList[3]],
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: Text("population".extensionCapitalize()),
                  onChanged: (value) {
                    setState(() => checkBoxValue["population"] = value!);
                  },
                  value: checkBoxValue["population"],
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: Text("tests".extensionCapitalize()),
                  value: checkBoxValue["tests"],
                  onChanged: (value) {
                    setState(() => checkBoxValue["tests"] = value!);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Okay"),
                onPressed: () {
                  Map<String, bool?> tempchb = Map.from(checkBoxValue);
                  tempchb.removeWhere((key, value) => value == false);
                  print('tempchb:  ' '${tempchb.keys.toList()}');
                  setState(
                    () => dataToShowHorizontalList = tempchb.keys.toList(),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
