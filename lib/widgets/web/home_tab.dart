import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/app_strings.dart';
import 'package:quickcare/constants/asset_constants.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:quickcare/provider/deviceslistprovider.dart';
import 'package:quickcare/provider/themeprovider.dart';
import 'package:quickcare/screens/web/mapscreen.dart';
import 'package:quickcare/widgets/web/brief_info_tile.dart';
import 'package:quickcare/widgets/web/devices_tab.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Map<int, int> devicesByMonth = {};
  String _devicesInstalledMonth = '3M';
  final int totalCups = 150;
  double randomFactor = 0;
  List<Device> topDeviceThisMonth = [];
  List<Device> mostUsedDevice = [];
  TooltipBehavior? _tooltipBehavior;
  bool isExpanded = true;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: 513.w,
              height: 600.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppStrings.deviceAdded,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.67,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0.w),
                          border: Border.all(color: Colors.white, width: 1.0),
                          color: const Color.fromARGB(255, 214, 214, 214),
                        ),
                        child: DropdownButton<String>(
                          value: _devicesInstalledMonth,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black),
                          iconSize: 24.w,
                          elevation: 16,
                          underline: Container(),
                          dropdownColor:
                              const Color.fromARGB(255, 214, 214, 214),
                          style: const TextStyle(color: Colors.black),
                          onChanged: (newValue) {
                            setState(() {
                              _devicesInstalledMonth = newValue as String;
                              randomFactor = double.parse(
                                  Random().nextDouble().toStringAsPrecision(2));
                            });
                          },
                          items: <String>['3M', '4M', '5M', '6M']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  SizedBox(
                    height: 170.h,
                    child: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                          name: AppStrings.numberOfDevices,
                          axisLine: const AxisLine(width: 0),
                          maximum: 5,
                          labelFormat: '{value}',
                          majorTickLines: const MajorTickLines(size: 0)),
                      series: _getDeviceInstallationSeries(),
                      tooltipBehavior: _tooltipBehavior,
                    ),
                  ),
                  SizedBox(
                    height: 43.h,
                  ),
                  Text(
                    AppStrings.topDevices,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.33,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    width: 514.w,
                    height: 252.h,
                    padding: EdgeInsets.only(top: 16.h),
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        topDeviceThisMonth =
                            Provider.of<DevicesListProvider>(context)
                                .devicesList
                                .where((element) =>
                                    element.history.last.time.month ==
                                    DateTime.now().month)
                                .toList();
                        topDeviceThisMonth.sort((a, b) =>
                            b.history.length.compareTo(a.history.length));

                        if (topDeviceThisMonth.isEmpty) {
                          return Center(
                            child: Text(
                              AppStrings.noInfoOfDevices,
                              style: TextStyle(
                                  color: DarkTheme.disabledWhite,
                                  fontSize: 14.sp),
                            ),
                          );
                        } else {
                          return Container(
                            width: 514.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 16.h),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF1C1F22),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.75.w,
                                    color: const Color(0xFFD5D5D5)),
                                borderRadius: BorderRadius.circular(106),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    topDeviceThisMonth.elementAt(index).devId,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                SizedBox(
                                  width: 178.w,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MapPage(
                                            afterMapLoad: () async {
                                              try {
                                                Fluttertoast.showToast(
                                                    msg: "Please wait ......");

                                                await googleMapController
                                                    .animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                    CameraPosition(
                                                      target: LatLng(
                                                          topDeviceThisMonth
                                                              .elementAt(index)
                                                              .latlng
                                                              .latitude,
                                                          topDeviceThisMonth
                                                              .elementAt(index)
                                                              .latlng
                                                              .latitude),
                                                      zoom: 15.5,
                                                    ),
                                                  ),
                                                );
                                              } catch (e) {
                                                dev.log(
                                                    "Error ocurred in animating camera position");
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Cannot take you there yet !");
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppStrings.location,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: DarkTheme.primaryBlue,
                                        color: DarkTheme.primaryBlue,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 16.h,
                        );
                      },
                      itemCount: topDeviceThisMonth.isEmpty
                          ? 1
                          : topDeviceThisMonth.length,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            VerticalDivider(
              color: Colors.grey.shade500,
              thickness: 0.75,
              width: 1,
              indent: 0,
              endIndent: 0,
            ),
            SizedBox(
              width: 20.w,
            ),
            SizedBox(
              height: 600.h,
              width: 342.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.mostUsedDevice,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.33,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    width: 342.w,
                    height: 300.h,
                    child: ListView.builder(
                      itemCount: Provider.of<DevicesListProvider>(context)
                          .devicesList
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        mostUsedDevice =
                            Provider.of<DevicesListProvider>(context)
                                .devicesList;
                        mostUsedDevice.sort((a, b) =>
                            b.history.length.compareTo(a.history.length));

                        var device = Provider.of<DevicesListProvider>(context)
                            .devicesList
                            .elementAt(index);

                        return Container(
                          color: Colors.transparent,
                          height: 60.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    mostUsedDevice.elementAt(index).devId,
                                    style: TextStyle(
                                        fontSize: 16.sp, color: Colors.white),
                                  ),
                                  Text(
                                    '${device.history.length} time${device.history.length > 1 ? "s" : ""} used',
                                    style: TextStyle(
                                        fontSize: 16.sp, color: Colors.white),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: Provider.of<DevicesListProvider>(context)
                                        .devicesList
                                        .elementAt(index)
                                        .timesRefilled
                                        .toDouble() /
                                    100,
                                backgroundColor:
                                    const Color.fromRGBO(22, 50, 77, 1),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BriefInfoTile(
                    headerWidget: CircleAvatar(
                        radius: 35.w,
                        backgroundColor: const Color(
                          0xffA23ED0,
                        ),
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.white,
                          size: 20.sp,
                        )),
                    subTitleText: Provider.of<DevicesListProvider>(context)
                        .devicesList
                        .length
                        .toString(),
                    titleText: AppStrings.locations,
                    backgroundColor:
                        Provider.of<ThemeProvider>(context).isDarkTheme
                            ? DarkTheme.tertiaryBackground
                            : LightTheme.tertiaryBackground,
                    textColor: Provider.of<ThemeProvider>(context).isDarkTheme
                        ? DarkTheme.primaryWhite
                        : LightTheme.textColorPrimary,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BriefInfoTile(
                    headerWidget: ClipRRect(
                      borderRadius: BorderRadius.circular(35.w),
                      child: Image.asset(
                        AssetConstants.dispenserImageAsset,
                        fit: BoxFit.fill,
                      ),
                    ),
                    subTitleText: Provider.of<DevicesListProvider>(context)
                        .devicesList
                        .length
                        .toString(),
                    titleText: AppStrings.numberOfDevices,
                    backgroundColor:
                        Provider.of<ThemeProvider>(context).isDarkTheme
                            ? DarkTheme.tertiaryBackground
                            : LightTheme.tertiaryBackground,
                    textColor: Provider.of<ThemeProvider>(context).isDarkTheme
                        ? DarkTheme.primaryWhite
                        : LightTheme.textColorPrimary,
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Map<int, int> groupDevicesByMonth() {
    Map<int, int> devicesByMonth = {};
    print(Provider.of<DevicesListProvider>(context, listen: false)
        .devicesList
        .length);
    Provider.of<DevicesListProvider>(context, listen: false)
        .devicesList
        .forEach((device) {
      int month = device.installedOn.month;

      if (devicesByMonth.containsKey(month)) {
        devicesByMonth[month] = devicesByMonth[month]! + 1;
      } else {
        devicesByMonth[month] = 1;
      }
    });

    print(devicesByMonth);

    return devicesByMonth;
  }

  List<ColumnSeries<ChartData, String>> _getDeviceInstallationSeries() {
    Map<int, int> devicesByMonth = groupDevicesByMonth();

    print(devicesByMonth);

    List<ChartData> chartDataList = devicesByMonth.entries.map((entry) {
      return ChartData(
          x: DateTime(DateTime.now().year - 1, entry.key),
          y: entry.value.toDouble());
    }).toList();

    return <ColumnSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        dataSource: chartDataList,
        xValueMapper: (ChartData data, _) => monthNumberToString(data.x.month),
        yValueMapper: (ChartData data, _) => data.y,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 10.sp, color: DarkTheme.primaryWhite),
        ),
      ),
    ];
  }

  List<ColumnSeries<ChartData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        dataSource: <ChartData>[
          ChartData(x: DateTime(DateTime.now().year, 1), y: 1 + randomFactor),
          ChartData(
              x: DateTime(DateTime.now().year, 2), y: 0.818 + randomFactor),
          ChartData(
              x: DateTime(DateTime.now().year, 3), y: 1.51 + randomFactor),
          ChartData(
              x: DateTime(DateTime.now().year, 4), y: 1.302 + randomFactor),
          ChartData(
              x: DateTime(DateTime.now().year, 5), y: 2.017 + randomFactor),
          ChartData(
              x: DateTime(DateTime.now().year, 6), y: 1.683 + randomFactor),
          ChartData(
              x: DateTime(DateTime.now().year, 7), y: 1.683 + randomFactor),
          ChartData(x: DateTime(DateTime.now().year, 8), y: 1.6 + randomFactor),
          ChartData(x: DateTime(DateTime.now().year, 9), y: 1.9 + randomFactor),
          ChartData(
              x: DateTime(DateTime.now().year, 10), y: 2.5 + randomFactor),
          ChartData(
              x: DateTime(DateTime.now().year, 11), y: 1.62 + randomFactor),
          ChartData(x: DateTime(DateTime.now().year, 12), y: 2 + randomFactor),
        ],
        xValueMapper: (ChartData sales, _) {
          return monthNumberToString(sales.x.month);
        },
        yValueMapper: (ChartData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle:
                TextStyle(fontSize: 10.sp, color: DarkTheme.primaryWhite)),
      )
    ];
  }
}

class ChartData {
  final DateTime x;
  final double y;

  ChartData({required this.x, required this.y});
}

int monthStringToNumber(String monthString) {
  switch (monthString.toLowerCase()) {
    case "january":
      return 1;
    case "february":
      return 2;
    case "march":
      return 3;
    case "april":
      return 4;
    case "may":
      return 5;
    case "june":
      return 6;
    case "july":
      return 7;
    case "august":
      return 8;
    case "september":
      return 9;
    case "october":
      return 10;
    case "november":
      return 11;
    case "december":
      return 12;
    default:
      throw FormatException("Invalid month string");
  }
}

String monthNumberToString(int monthNum) {
  switch (monthNum) {
    case 1:
      return "Jan";
    case 2:
      return "Feb";
    case 3:
      return "Mar";
    case 4:
      return "Apr";
    case 5:
      return "May";
    case 6:
      return "Jun";
    case 7:
      return "Jul";
    case 8:
      return "Aug";
    case 9:
      return "Sep";
    case 10:
      return "Oct";
    case 11:
      return "Nov";
    case 12:
      return "Dec";
    default:
      throw FormatException("Invalid month string");
  }
}
