
import 'package:covid19/pages/home.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';

void main(List<String> args) {
  runApp(const Covid19());
}

class Covid19 extends StatelessWidget {
  const Covid19({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Color.fromARGB(255, 51, 51, 51),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Covid 19"),
        ),
        drawer: const CovidAppDrawer(),
        body: const HomePage(),
      ),
    );
  }
}
