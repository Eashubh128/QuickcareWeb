import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/helpers/chart_helper.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:quickcare/provider/deviceslistprovider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/helpers/chart_helper.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:quickcare/provider/deviceslistprovider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DataChart extends StatefulWidget {
  final int chartType;
  final int offset;

  const DataChart({
    Key? key,
    required this.chartType,
    required this.offset,
  }) : super(key: key);

  @override
  State<DataChart> createState() => _DataChartState();
}

class _DataChartState extends State<DataChart> {
  TrackballBehavior? _trackballBehavior;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devicesProvider = Provider.of<DevicesListProvider>(context);
    final device =
        devicesProvider.selectedDevice ?? devicesProvider.devicesList.first;
    final frequency = devicesProvider.selectedFrequency;

    final chartData = filterChartData(device.history, frequency, widget.offset);
    bool showAsLineChart = devicesProvider.showAsLineChart();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        maximum: 100,
        minimum: 0,
        interval: 10,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: showAsLineChart
          ? _getLineSeries(widget.chartType, chartData)
          : _getChartSeries(widget.chartType, chartData),
      trackballBehavior: _trackballBehavior,
      tooltipBehavior: TooltipBehavior(
          enable: true,
          color: Colors.white,
          // builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          //     int seriesIndex) {
          //   return Container(
          //       height: 50,
          //       width: 100,
          //       child: Text('$pointIndex'),
          //       decoration: const BoxDecoration(
          //         color: DarkTheme.disabledWhite,
          //       ));
          // },
          textStyle: const TextStyle(color: DarkTheme.primaryBackground)),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
    );
  }

  List<CartesianSeries<ChartSampleData, String>> _getLineSeries(
      int chartType, List<ChartSampleData> chartData) {
    switch (chartType) {
      case 1: // Battery
        return [
          LineSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.startBattRem,
            name: 'Battery Start',
            color: DarkTheme.primaryGreen.withOpacity(0.7),
            markerSettings: const MarkerSettings(isVisible: true),
            dataLabelSettings:
                const DataLabelSettings(isVisible: true, color: Colors.white),
          ),
          LineSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.endBattRem,
            name: 'Battery End',
            color: DarkTheme.primaryGreen,
            markerSettings: const MarkerSettings(isVisible: true),
            dataLabelSettings:
                const DataLabelSettings(isVisible: true, color: Colors.white),
          ),
        ];
      case 2: // Battery
        return [
          LineSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.startCupsRem,
            name: 'Cups Start',
            color: DarkTheme.primaryBlue.withOpacity(0.7),
            markerSettings: MarkerSettings(isVisible: true),
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
          LineSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.endCupsRem,
            name: 'Cups End',
            color: DarkTheme.primaryBlue,
            markerSettings: MarkerSettings(isVisible: true),
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ];
      case 3:
        return [
          LineSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.startWashRem1,
            name: 'Liquid Start',
            color: DarkTheme.primaryPurple.withOpacity(0.7),
            markerSettings: MarkerSettings(isVisible: true),
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
          LineSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.endWashRem1,
            name: 'Liquid End',
            color: DarkTheme.primaryPurple,
            markerSettings: MarkerSettings(isVisible: true),
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ];
      default:
        return [];
    }
  }

  List<CartesianSeries<ChartSampleData, String>> _getChartSeries(
      int chartType, List<ChartSampleData> chartData) {
    switch (chartType) {
      case 1: // Battery
        return [
          RangeColumnSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            lowValueMapper: (ChartSampleData data, _) => data.startBattRem,
            highValueMapper: (ChartSampleData data, _) => data.endBattRem,
            name: 'Battery',
            color: DarkTheme.primaryGreen,
          ),
        ];
      case 2: // Cups
        return [
          RangeColumnSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            lowValueMapper: (ChartSampleData data, _) => data.startCupsRem,
            highValueMapper: (ChartSampleData data, _) => data.endCupsRem,
            name: 'Cups',
            color: DarkTheme.primaryBlue,
          ),
        ];
      case 3: // Liquid
        return [
          RangeColumnSeries<ChartSampleData, String>(
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            lowValueMapper: (ChartSampleData data, _) => data.startWashRem1,
            highValueMapper: (ChartSampleData data, _) => data.endWashRem1,
            name: 'Liquid',
            color: DarkTheme.primaryRed,
          ),
        ];
      default:
        return [];
    }
  }
}

class ChartSampleData {
  final String x;
  final num? startBattRem;
  final num? startCupsRem;
  final num? startWashRem1;
  final num? endBattRem;
  final num? endCupsRem;
  final num? endWashRem1;

  ChartSampleData({
    required this.x,
    this.startBattRem,
    this.startCupsRem,
    this.startWashRem1,
    this.endBattRem,
    this.endCupsRem,
    this.endWashRem1,
  });
}

// class ChartSampleData {
//   ChartSampleData({
//     this.x,
//     this.y,
//     this.xValue,
//     this.yValue,
//     this.secondSeriesYValue,
//     this.thirdSeriesYValue,
//   });

//   /// Holds x value of the datapoint
//   final dynamic x;

//   /// Holds y value of the datapoint
//   final num? y;

//   /// Holds x value of the datapoint
//   final dynamic xValue;

//   /// Holds y value of the datapoint
//   final num? yValue;

//   /// Holds y value of the datapoint(for 2nd series)
//   final num? secondSeriesYValue;

//   /// Holds y value of the datapoint(for 3nd series)
//   final num? thirdSeriesYValue;
// }

Color getColorBasedOnValue(num? y) {
  if (y! > 51) {
    return DarkTheme.primaryGreen;
  } else if (y < 21) {
    return DarkTheme.primaryRed;
  }
  return Colors.yellow;
}
