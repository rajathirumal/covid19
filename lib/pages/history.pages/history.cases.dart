import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:covid19/source/moc.data.dart';

class Cases extends StatefulWidget {
  String dataForCountry;
  Cases(this.dataForCountry, {Key? key}) : super(key: key);

  @override
  _CasesState createState() => _CasesState(dataForCountry);
}

class _CasesState extends State<Cases> {
  late List<CasesData> _caseData;
  late TooltipBehavior _tooltipBehavior;
  String dataForCountry;

  @override
  void initState() {
    _caseData = getCaseData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  _CasesState(this.dataForCountry);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SafeArea(
        child: Scaffold(
          body: SfCartesianChart(
            title: ChartTitle(text: "Number of cases"),
            tooltipBehavior: _tooltipBehavior,
            series: <ChartSeries>[
              LineSeries<CasesData, int>(
                  name: "Number of cases",
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                  dataSource: _caseData,
                  xValueMapper: (CasesData cd, _) => cd.date,
                  yValueMapper: (CasesData cd, _) => cd.count),
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

  List<CasesData> getCaseData() {
    Map<String, int> dataOnPage = (MocData.historicData.firstWhere(
      (element) => element["country"] == dataForCountry,
    ))["timeline"]["cases"];

    List<CasesData> CaseDataList = [];
    for (var d in dataOnPage.keys) {
      num caseCount = dataOnPage[d] ?? 0;
      caseCount = caseCount / 1000;
      CaseDataList.add(CasesData(int.parse(d.split("/")[1]), caseCount));
    }
    return CaseDataList;
  }
}

class CasesData {
  CasesData(
    this.date,
    this.count,
  );
  final int date;
  final num count;
}
