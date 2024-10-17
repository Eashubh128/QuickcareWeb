import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickcare/controllers/notification_controller.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:http/http.dart' as http;
import 'package:quickcare/secrets/map_key.dart';
import 'package:quickcare/widgets/web/data_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DevicesListProvider extends ChangeNotifier {
  Stream<List<Device>>? _devicesListStream;
  List<Device> filteredDevices = [];
  List<Device> devicesList = [];
  String _selectedFrequency = 'Daily';
  Device? _selectedDevice;
  String get selectedFrequency => _selectedFrequency;
  Device? get selectedDevice => _selectedDevice;
  Set<String> _selectedDeviceTypes = {};
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _searchQuery;

  bool _showAsLineChart = true;

  void toggleChartType() {
    _showAsLineChart = !_showAsLineChart;
    ;
    notifyListeners();
  }

  bool showAsLineChart() {
    return _showAsLineChart;
  }

  void setSelectedFrequency(String frequency) {
    _selectedFrequency = frequency;
    notifyListeners();
  }

  void setSelectedDevice(Device newDevice) {
    _selectedDevice = newDevice;
    notifyListeners();
  }

  DevicesListProvider() {
    getDeviceListStream();
  }

  Stream<List<Device>> getDeviceListStream() {
    try {
      StreamController<List<Device>> _streamController =
          StreamController<List<Device>>.broadcast();
      List<Device> _devicesList = [];
      FirebaseFirestore.instance
          .collection("devices")
          .snapshots()
          .listen((event) async {
        _devicesList.clear();
        devicesList.clear();
        print(event);
        for (var docs in event.docs) {
          print(docs.data().toString());
          Device tempDevice = Device.fromJson(docs.data());
          tempDevice.formattedAddress = await getAddressFromlatlng(
              tempDevice.latlng.latitude, tempDevice.latlng.longitude);
          print(tempDevice.toString());
          _devicesList.add(tempDevice);
          devicesList.add(tempDevice);
          if (tempDevice.battRem < 30 ||
              tempDevice.cupsRem < 25 ||
              tempDevice.liquidRem < 25) {
            NotificationController.createNotification(tempDevice.devId);
          }
          notifyListeners();
        }
        _selectedDevice = devicesList.firstOrNull;
        _streamController.add(devicesList);
      });

      return _streamController.stream;
    } catch (e) {
      log("Error ocurred in getting devices list ");
      throw ("Error ocurred in getDeviceListStream");
    }
  }

  static Future<String> getAddressFromlatlng(
      double latitude, double longitude) async {
    try {
      Uri uri = Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$MAPS_KEY");
      var response = await http.get(uri);
      var result = jsonDecode(response.body);
      return result["results"][0]["formatted_address"];
    } catch (e) {
      return "Unknown address";
    }
  }

  List<History> getFilteredHistory(Device device, int offset) {
    final now = DateTime.now();
    final date = now.subtract(Duration(days: offset * _getDaysPerPeriod()));

    switch (_selectedFrequency) {
      case 'Daily':
        return device.history
            .where((h) =>
                h.time.year == date.year &&
                h.time.month == date.month &&
                h.time.day == date.day)
            .toList();
      case 'Weekly':
        final weekStart = date.subtract(Duration(days: date.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 7));
        return device.history
            .where((h) => h.time.isAfter(weekStart) && h.time.isBefore(weekEnd))
            .toList();
      case 'Monthly':
        return device.history
            .where(
                (h) => h.time.year == date.year && h.time.month == date.month)
            .toList();
      default:
        return device.history;
    }
  }

  int _getDaysPerPeriod() {
    switch (_selectedFrequency) {
      case 'Daily':
        return 1;
      case 'Weekly':
        return 7;
      case 'Monthly':
        return 30;
      default:
        return 1;
    }
  }

  sortDevices([int Function(Device, Device)? compare]) {
    devicesList.sort(compare);

    devicesList.forEach(
      (element) => element.devId,
    );

    notifyListeners();
  }

  void filterDevices() {
    filteredDevices = List.from(devicesList);

    // Apply CSC filter
    if (_selectedCountry != null ||
        _selectedState != null ||
        _selectedCity != null) {
      filteredDevices = filteredDevices.where((device) {
        List<String> cscParts = device.cscDetails.split(',');
        return (_selectedCountry == null ||
                cscParts[0].trim() == _selectedCountry) &&
            (_selectedState == null || cscParts[1].trim() == _selectedState) &&
            (_selectedCity == null || cscParts[2].trim() == _selectedCity);
      }).toList();
    }

    // Apply search filter
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      filteredDevices = filteredDevices
          .where((device) =>
              device.devId
                  .toLowerCase()
                  .contains(_searchQuery!.toLowerCase()) ||
              device.contactPersonNumber
                  .toLowerCase()
                  .contains(_searchQuery!.toLowerCase()) ||
              device.clientName
                  .toLowerCase()
                  .contains(_searchQuery!.toLowerCase()))
          .toList();
    }

    // Apply device type filter
    if (_selectedDeviceTypes.isNotEmpty) {
      filteredDevices = filteredDevices
          .where((device) => _selectedDeviceTypes.contains(device.deviceType))
          .toList();
    }

    notifyListeners();
  }

  void setCSCFilter(String? country, String? state, String? city) {
    _selectedCountry = country;
    _selectedState = state;
    _selectedCity = city;
    filterDevices();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    filterDevices();
  }

  bool isDeviceTypeSelected(String deviceType) {
    return _selectedDeviceTypes.contains(deviceType);
  }

  void toggleDeviceType(String deviceType) {
    if (_selectedDeviceTypes.contains(deviceType)) {
      _selectedDeviceTypes.remove(deviceType);
    } else {
      _selectedDeviceTypes.add(deviceType);
    }
    filterDevices();
  }
  // void toggleDeviceType(String deviceType) {
  //   if (_selectedDeviceTypes.contains(deviceType)) {
  //     _selectedDeviceTypes.remove(deviceType);
  //   } else {
  //     _selectedDeviceTypes.add(deviceType);
  //   }
  //   filterDevices();
  // }

  void clearFilters() {
    _selectedCountry = null;
    _selectedState = null;
    _selectedCity = null;
    _searchQuery = null;
    _selectedDeviceTypes.clear();
    filterDevices();
  }

  bool get areFiltersActive =>
      _selectedCountry != null ||
      _selectedState != null ||
      _selectedCity != null ||
      (_searchQuery != null && _searchQuery!.isNotEmpty) ||
      _selectedDeviceTypes.isNotEmpty;
}
