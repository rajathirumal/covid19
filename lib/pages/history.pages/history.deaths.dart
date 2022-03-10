import 'package:flutter/material.dart';
import 'package:covid19/source/moc.data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Deaths extends StatefulWidget {
  String dataForCountry;
  Deaths(this.dataForCountry, {Key? key}) : super(key: key);

  @override
  _DeathsState createState() => _DeathsState(dataForCountry);
}

class _DeathsState extends State<Deaths> {
  late List<DeathData> _deathData;
  late Map<String, int> dataOnPage;
  late TooltipBehavior _tooltipBehavior;
  String dataForCountry;
  @override
  void initState() {
    _deathData = getDeathCount();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  _DeathsState(this.dataForCountry);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SafeArea(
        child: Scaffold(
          body: SfCartesianChart(
            title: ChartTitle(
                text:
                    "Number of deaths on the year 20${dataOnPage.keys.first.split("/")[2]}"),
            tooltipBehavior: _tooltipBehavior,
            series: <ChartSeries>[
              LineSeries<DeathData, int>(
                  name: "Number of deaths",
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                  dataSource: _deathData,
                  xValueMapper: (DeathData cd, _) => cd.date,
                  yValueMapper: (DeathData cd, _) => cd.count),
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

  List<DeathData> getDeathCount() {
    dataOnPage = (MocData.historicData.firstWhere(
      (element) => element["country"] == dataForCountry,
    ))["timeline"]["deaths"];

    List<DeathData> dethDataList = [];
    for (var d in dataOnPage.keys) {
      num deathCount = dataOnPage[d] ?? 0;
      deathCount = deathCount / 100;
      dethDataList.add(
        DeathData(int.parse(d.split("/")[1]), deathCount),
      );
    }
    return dethDataList;
  }
}

class DeathData {
  DeathData(
    this.date,
    this.count,
  );
  final int date;
  final num count;
}
