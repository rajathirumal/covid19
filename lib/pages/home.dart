import 'package:flutter/material.dart';

import '../drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Covid 19"),
      ),
      drawer: const CovidAppDrawer(),
      body: Container(),
    );
  }
}
