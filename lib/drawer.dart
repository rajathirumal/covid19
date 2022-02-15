import 'package:covid19/pages/country.dart';
import 'package:flutter/material.dart';

class CovidAppDrawer extends StatelessWidget {
  const CovidAppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 245, 113, 104),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  // Call buildMenuItem() for the required drawer items
                  //
                  // buildMenuItem(
                  //   menutext: 'People',
                  //   menuicon: Icons.people,
                  // ),
                  //
                  // Callin buildMenuItem() should be above this comment
                  buildMenuItem(
                    menutext: "COUNTRY",
                    menuicon: Icons.stream_outlined,
                    Onmenuitemclick: () => selectedItem(context, 1),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String menutext,
    required IconData menuicon,
    required VoidCallback? Onmenuitemclick,
  }) {
    const color = Colors.white;
    const menuHoverColor = Colors.white70;

    return ListTile(
      leading: Icon(
        menuicon,
        color: color,
      ),
      title: Text(
        menutext,
        style: const TextStyle(color: color),
      ),
      onTap: Onmenuitemclick,
      hoverColor: menuHoverColor,
    );
  }

  void selectedItem(BuildContext context, int itemIndex) {
    Map<String, dynamic> ownContext = {"showCountryPick": true};
    Navigator.of(context).pop();
    switch (itemIndex) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Country(countryData: ownContext)));
        break;
      default:
    }
  }
}
