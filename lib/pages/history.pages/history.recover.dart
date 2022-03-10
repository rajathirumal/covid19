import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:covid19/source/moc.data.dart';

class Recover extends StatefulWidget {
  String dataForCountry;
  Recover(this.dataForCountry, {Key? key}) : super(key: key);

  @override
  _RecoverState createState() => _RecoverState(dataForCountry);
}

class _RecoverState extends State<Recover> {
  late List<RecoverData> _recoverData;
  late TooltipBehavior _tooltipBehavior;
  late Map<String, int> dataOnPage;
  String dataForCountry;

  @override
  void initState() {
    _recoverData = getRecoverData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  _RecoverState(this.dataForCountry);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SafeArea(
        child: Scaffold(
          body: SfCartesianChart(
            title: ChartTitle(
                text:
                    "Number of recoverd on 20${dataOnPage.keys.first.split("/")[2]}\n ${dataForCountry}"),
            tooltipBehavior: _tooltipBehavior,
            series: <ChartSeries>[
              LineSeries<RecoverData, int>(
                  name: "Number of recovery",
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                  dataSource: _recoverData,
                  xValueMapper: (RecoverData cd, _) => cd.date,
                  yValueMapper: (RecoverData cd, _) => cd.count),
            ],
            primaryXAxis: NumericAxis(
                labelFormat:
                    '{value}/${DateTime.now().toString().split("-")[1]}',
                edgeLabelPlacement: EdgeLabelPlacement.shift),
            primaryYAxis: NumericAxis(
                labelFormat: '{value}K',
                edgeLabelPlacement: EdgeLabelPlacement.shift),
          ),
        ),
      ),
    );
  }

  List<RecoverData> getRecoverData() {
    dataOnPage = (MocData.historicData.firstWhere(
      (element) => element["country"] == dataForCountry,
    ))["timeline"]["recovered"];

    List<RecoverData> recoverDataList = [];
    for (var c in dataOnPage.keys) {
      num recoverCount = dataOnPage[c] ?? 0;
      recoverCount = recoverCount / 1000;
      recoverDataList.add(
        RecoverData(int.parse(c.split("/")[1]), recoverCount),
      );
    }
    return recoverDataList;
  }
}

class RecoverData {
  RecoverData(
    this.date,
    this.count,
  );
  final int date;
  final num count;
}
