import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/app_strings.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/helpers/chart_helper.dart';
import 'package:quickcare/helpers/excel_helper.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:quickcare/provider/deviceslistprovider.dart';
import 'package:quickcare/provider/themeprovider.dart';
import 'package:quickcare/widgets/web/chart_navigation.dart';
import 'package:quickcare/widgets/web/charts_navigation.dart';
import 'package:quickcare/widgets/web/data_chart.dart';
import 'package:quickcare/widgets/web/device_detail_tile.dart';

class LiveDataTab extends StatefulWidget {
  const LiveDataTab({super.key});

  @override
  State<LiveDataTab> createState() => _LiveDataTabState();
}

class _LiveDataTabState extends State<LiveDataTab>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final double width = 10;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  int _offset = 0;
  int random = 0;

  List<Device> _filteredDevices = [];
  bool isApplyFiltersClicked = false;
  Device? selectedDevice;
  bool isInvoicing = true;

  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;

  int touchedGroupIndex = -1;

  void _filterDevices(String query) {
    final devices =
        Provider.of<DevicesListProvider>(context, listen: false).devicesList;
    setState(() {
      _filteredDevices = devices
          .where((device) =>
              device.devId.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // void _applyFilters() {
  //   final deviceListProvider =
  //       Provider.of<DevicesListProvider>(context, listen: false);
  //   deviceListProvider.filterDevices(
  //     country: selectedCountry,
  //     state: selectedState,
  //     city: selectedCity,
  //     searchQuery: _searchController.text,
  //   );
  // }

  ThemeData _buildDateRangePickerTheme() {
    return ThemeData(
      primaryColor: DarkTheme.primaryBlue,
      hintColor: DarkTheme.primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: DarkTheme.primaryBlue,
        onPrimary: Colors.white,
        surface: Color(0xFF1C1F22),
        onSurface: DarkTheme.primaryWhite,
      ),
      dialogBackgroundColor: DarkTheme.secondaryBackground,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DarkTheme.primaryBlue,
        ),
      ),
    );
  }

  Future<DateTimeRange?> _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: _buildDateRangePickerTheme(),
          child: child!,
        );
      },
    );

    return newDateRange;
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      animationDuration: const Duration(milliseconds: 500),
      vsync: this,
    );
    selectedDevice = Provider.of<DevicesListProvider>(context, listen: false)
        .devicesList
        .firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final deviceListProvider = Provider.of<DevicesListProvider>(context);
    print(
        "=========================Building LiveData Tab==========================");
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Live Data ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.67,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 20.w,
            ),
            Visibility(
              visible: !isApplyFiltersClicked,
              child: InkWell(
                onTap: () {
                  isApplyFiltersClicked = true;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  height: 48.h,
                  width: 165.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0.w),
                      border: Border.all(color: Colors.white, width: 1.0),
                      color: Colors.transparent),
                  child: Center(
                    child: Text(
                      "Apply filters",
                      style: TextStyle(
                        color: Provider.of<ThemeProvider>(context).isDarkTheme
                            ? DarkTheme.primaryWhite
                            : LightTheme.textColorPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            InkWell(
              onTap: () async {
                _searchController.clear();
                _isSearching = !_isSearching;
                setState(() {});

                final DateTimeRange? dateRange =
                    await _selectDateRange(context);

                if (isApplyFiltersClicked == true) {
                  if (deviceListProvider.filteredDevices.isEmpty) {
                    Fluttertoast.showToast(
                        toastLength: Toast.LENGTH_LONG,
                        msg:
                            "No devices were filtered , please use a different filter.");
                  } else {
                    if (dateRange != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                      await ExcelHelper.createExcelFile(
                          deviceListProvider.filteredDevices,
                          dateRange.start,
                          dateRange.end,
                          isInvoicing: isInvoicing);

                      Navigator.of(context).pop();
                    }
                  }
                } else if (isApplyFiltersClicked == false) {
                  Fluttertoast.showToast(
                      toastLength: Toast.LENGTH_LONG,
                      msg: "Applied range filter ..... downloading");
                  if (dateRange != null) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                    await ExcelHelper.createExcelFile(
                        deviceListProvider.devicesList,
                        dateRange.start,
                        dateRange.end,
                        isInvoicing: false);

                    Navigator.of(context).pop();
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                height: 48.h,
                width: 165.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0.w),
                    border: Border.all(color: Colors.white, width: 1.0),
                    color: Colors.transparent),
                child: Center(
                  child: Text(
                    AppStrings.exportToCSV,
                    style: TextStyle(
                      color: Provider.of<ThemeProvider>(context).isDarkTheme
                          ? DarkTheme.primaryWhite
                          : LightTheme.textColorPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Visibility(
            visible: isApplyFiltersClicked,
            child: SizedBox(
              height: 20.h,
            )),
        Visibility(
            visible: isApplyFiltersClicked,
            child: Row(
              children: [
                SizedBox(
                  width: 200.w,
                  child: CSCPicker(
                    onCountryChanged: (country) {
                      deviceListProvider.setCSCFilter(country, null, null);
                    },
                    onStateChanged: (state) {
                      deviceListProvider.setCSCFilter(null, state, null);
                    },
                    onCityChanged: (city) {
                      deviceListProvider.setCSCFilter(null, null, city);
                    },
                    countryDropdownLabel: "Country",
                    flagState: CountryFlag.DISABLE,
                    stateDropdownLabel: "State",
                    cityDropdownLabel: "City",
                    dropdownDialogRadius: 10.0,
                    searchBarRadius: 10.0,
                  ),
                ),
                SizedBox(
                  width: 50.w,
                ),
                FilterChip(
                  label: Text('Automatic'),
                  selected:
                      deviceListProvider.isDeviceTypeSelected('Automatic'),
                  onSelected: (selected) {
                    deviceListProvider.toggleDeviceType('Automatic');
                  },
                ),
                SizedBox(width: 8.w),
                FilterChip(
                  label: Text('Semi-Automatic'),
                  selected:
                      deviceListProvider.isDeviceTypeSelected('Semi-automatic'),
                  onSelected: (selected) {
                    deviceListProvider.toggleDeviceType('Semi-automatic');
                  },
                ),
                SizedBox(width: 8.w),
                FilterChip(
                  label: Text('Manual'),
                  selected: deviceListProvider.isDeviceTypeSelected('Manual'),
                  onSelected: (selected) {
                    deviceListProvider.toggleDeviceType('Manual');
                  },
                ),
                SizedBox(
                  width: 50.w,
                ),
                SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Invoicing",
                        style: TextStyle(color: DarkTheme.primaryWhite),
                      ),
                      Switch(
                          value: isInvoicing,
                          onChanged: (value) {
                            isInvoicing = value;
                            setState(() {});
                          }),
                      const Text(
                        "Detailed",
                        style: TextStyle(color: DarkTheme.primaryWhite),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    isApplyFiltersClicked = !isApplyFiltersClicked;
                    _isSearching = !_isSearching;
                    deviceListProvider.clearFilters();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: DarkTheme.primaryWhite,
                  ),
                )
              ],
            )),
        SizedBox(
          height: 43.5.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.w,
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).isDarkTheme
                      ? DarkTheme.primaryWhite
                      : LightTheme.textColorPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.searchDevices,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Provider.of<ThemeProvider>(context).isDarkTheme
                        ? DarkTheme.primaryWhite
                        : LightTheme.textColorPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xFFD5D5D5),
                    ),
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xFFD5D5D5),
                    ),
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _isSearching = value.isNotEmpty;
                  });
                  deviceListProvider.setSearchQuery(value);
                },
              ),
            ),
            const Spacer(),
            !_isSearching
                ? Container(
                    width: 480.w,
                    height: 67.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360.w),
                        color: Provider.of<ThemeProvider>(context).isDarkTheme
                            ? DarkTheme.secondaryBackground
                            : LightTheme.secondaryBackground,
                        border: Border.all(color: DarkTheme.primaryBorder)),
                    child: TabBar(
                      controller: _tabController,
                      labelPadding: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      dividerColor: Colors.transparent,
                      indicatorWeight: 0,
                      indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(50), // Creates border
                        color: DarkTheme.primaryBlue,
                      ),
                      tabs: [
                        Container(
                          width: 179.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360)),
                          child: Center(
                            child: Text(
                              AppStrings.battery,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  color: DarkTheme.primaryWhite),
                            ),
                          ),
                        ),
                        Container(
                            width: 179.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360)),
                            child: Center(
                              child: Text(
                                AppStrings.cups,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    color: DarkTheme.primaryWhite),
                              ),
                            )),
                        Container(
                          width: 179.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360)),
                          child: Center(
                            child: Text(
                              AppStrings.liquid,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  color: DarkTheme.primaryWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              width: 20.w,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0.w),
                border: Border.all(color: Colors.white, width: 1.0),
                color: const Color.fromARGB(255, 214, 214, 214),
              ),
              child: DropdownButton<String>(
                value: deviceListProvider.selectedFrequency,
                icon:
                    const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                iconSize: 24.w,
                elevation: 16,
                underline: Container(),
                dropdownColor: const Color.fromARGB(255, 214, 214, 214),
                style: const TextStyle(color: Colors.black),
                onChanged: (newValue) {
                  deviceListProvider.setSelectedFrequency(newValue!);
                },
                items: <String>['Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
        Expanded(
          child: SizedBox(
            width: 864.w,
            child: ListView.separated(
              itemBuilder: (context, index) {
                if (shouldShowChart() && index == 0) {
                  return drawChart(deviceListProvider.selectedFrequency);
                } else {
                  final devicesList = isApplyFiltersClicked || _isSearching
                      ? deviceListProvider.filteredDevices
                      : deviceListProvider.devicesList;

                  final deviceIndex = shouldShowChart() ? index - 1 : index;
                  final device = devicesList[deviceIndex];
                  return DeviceDetailTile(device: device);
                }
              },
              separatorBuilder: (context, index) => SizedBox(height: 24.h),
              itemCount: (isApplyFiltersClicked || _isSearching
                      ? deviceListProvider.filteredDevices.length
                      : deviceListProvider.devicesList.length) +
                  (shouldShowChart() ? 1 : 0),
            ),
          ),
        ),
      ],
    );
  }

  bool shouldShowChart() {
    return (!_isSearching && !isApplyFiltersClicked) ||
        (isApplyFiltersClicked && !_isSearching);
  }

  Widget drawChart(String selectedFrequency) {
    return Column(
      children: [
        ChartNavigation(
          frequency: selectedFrequency,
          offset: _offset,
          onOffsetChanged: (newOffset) {
            setState(() {
              _offset = newOffset;
            });
          },
        ),
        Container(
          width: 864.w,
          height: 303.h,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30.h),
          child: TabBarView(
            controller: _tabController,
            children: [
              DataChart(chartType: 1, offset: _offset),
              DataChart(chartType: 2, offset: _offset),
              DataChart(chartType: 3, offset: _offset),
            ],
          ),
        ),
      ],
    );
  }
}
