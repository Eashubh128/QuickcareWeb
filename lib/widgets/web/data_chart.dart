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
  bool isCardView = true;
  List<ChartSampleData> chartData = [];
  TooltipBehavior? _tooltipBehavior;
  late double _columnWidth;
  late double _columnSpacing;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _columnWidth = 0.8;
    _columnSpacing = 0.2;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devicesProvider = Provider.of<DevicesListProvider>(context);
    final device =
        devicesProvider.selectedDevice ?? devicesProvider.devicesList.first;

    final filteredHistory =
        devicesProvider.getFilteredHistory(device, widget.offset);
    final chartData = _getChartData(filteredHistory, widget.chartType);
    // final device =
    //     devicesProvider.selectedDevice ?? devicesProvider.devicesList.first;

    // final filteredHistory = devicesProvider.getFilteredHistory(device);
    // final chartData = _getChartData(filteredHistory, widget.chartType);
    print("=========================Building Charts==========================");
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
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
      series: _getDefaultColumn(widget.chartType, chartData),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<ChartSampleData> _getChartData(List<History> history, int chartType) {
    return history.map((h) {
      switch (chartType) {
        case 1:
          return ChartSampleData(x: h.time.toString(), y: h.battRem);
        case 2:
          return ChartSampleData(
              x: h.time.toString(), secondSeriesYValue: h.cupsRem);
        case 3:
          return ChartSampleData(
              x: h.time.toString(), thirdSeriesYValue: h.washRem1);
        default:
          throw Exception('Invalid chart type');
      }
    }).toList();
  }

  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumn(
      int chartType, List<ChartSampleData> chartData) {
    switch (chartType) {
      case 1:
        return <ColumnSeries<ChartSampleData, String>>[
          ColumnSeries<ChartSampleData, String>(
            width: isCardView ? 0.8 : _columnWidth,
            spacing: isCardView ? 0.2 : _columnSpacing,
            dataSource: chartData,
            xValueMapper: (ChartSampleData sales, _) => sales.x as String,
            yValueMapper: (ChartSampleData sales, _) => sales.y!,
            pointColorMapper: (ChartSampleData sales, _) =>
                getColorBasedOnValue(sales.y),
            name: 'Battery',
          ),
        ];
      case 2:
        return <ColumnSeries<ChartSampleData, String>>[
          ColumnSeries<ChartSampleData, String>(
            dataSource: chartData,
            width: isCardView ? 0.8 : _columnWidth,
            spacing: isCardView ? 0.2 : _columnSpacing,
            color: DarkTheme.primaryBlue,
            xValueMapper: (ChartSampleData sales, _) => sales.x as String,
            yValueMapper: (ChartSampleData sales, _) =>
                sales.secondSeriesYValue!,
            name: 'Cups',
          ),
        ];
      case 3:
        return <ColumnSeries<ChartSampleData, String>>[
          ColumnSeries<ChartSampleData, String>(
            dataSource: chartData,
            width: isCardView ? 0.8 : _columnWidth,
            spacing: isCardView ? 0.2 : _columnSpacing,
            xValueMapper: (ChartSampleData sales, _) => sales.x as String,
            yValueMapper: (ChartSampleData sales, _) =>
                sales.thirdSeriesYValue!,
            pointColorMapper: (ChartSampleData sales, _) =>
                getColorBasedOnValue(sales.thirdSeriesYValue),
            name: 'Liquid 1',
          ),
        ];
      case 4:
        return <ColumnSeries<ChartSampleData, String>>[
          ColumnSeries<ChartSampleData, String>(
            dataSource: chartData,
            width: isCardView ? 0.8 : _columnWidth,
            spacing: isCardView ? 0.2 : _columnSpacing,
            xValueMapper: (ChartSampleData sales, _) => sales.x as String,
            yValueMapper: (ChartSampleData sales, _) =>
                sales.thirdSeriesYValue!,
            pointColorMapper: (ChartSampleData sales, _) =>
                getColorBasedOnValue(sales.thirdSeriesYValue),
            name: 'Liquid 2',
          ),
        ];
      default:
        return [];
    }
  }
}

class ChartSampleData {
  ChartSampleData({
    this.x,
    this.y,
    this.xValue,
    this.yValue,
    this.secondSeriesYValue,
    this.thirdSeriesYValue,
  });

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;
}

Color getColorBasedOnValue(num? y) {
  if (y! > 51) {
    return DarkTheme.primaryGreen;
  } else if (y < 21) {
    return DarkTheme.primaryRed;
  }
  return Colors.yellow;
}
