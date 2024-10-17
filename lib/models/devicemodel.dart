import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:quickcare/models/addressmodel.dart';

Device deviceFromJson(String str) => Device.fromJson(json.decode(str));

class Device with ClusterItem {
  String macAdr;
  String devId;
  num battRem;
  num cupsRem;
  num liquidRem;
  num liquidRem2;
  GeoPoint latlng;
  String formattedAddress;
  DateTime lastUpdated;
  DateTime installedOn;
  String installedBy;
  int timesRefilled;
  DateTime lastRefilled;
  final List<History> history;
  Address? address;
  String wifiId;
  String wifiPass;
  String clientName;
  String clientAddress;
  String clientNo;
  String floorInfo;
  String postCodePlace;
  String deviceType;
  String cscDetails;
  String contactPersonName;
  String contactPersonNumber;
  String deviceSerialNo;

  Device(
      {required this.macAdr,
      required this.devId,
      required this.battRem,
      required this.cupsRem,
      required this.liquidRem2,
      required this.installedBy,
      required this.lastRefilled,
      required this.latlng,
      required this.lastUpdated,
      required this.liquidRem,
      required this.installedOn,
      required this.history,
      required this.timesRefilled,
      required this.formattedAddress,
      required this.address,
      this.clientAddress = "NA",
      this.deviceType = "NA",
      this.clientName = "NA",
      this.floorInfo = "NA",
      this.postCodePlace = "NA",
      this.wifiPass = "",
      this.wifiId = "",
      this.cscDetails = "",
      this.contactPersonName = "",
      this.contactPersonNumber = "",
      this.deviceSerialNo = "",
      this.clientNo = ""});

  static DateTime convertToDate(String inputDateString) {
    if (inputDateString.isEmpty || inputDateString == null) {
      return DateTime(0000, 1, 0, 0, 0, 0);
    } else {
      List<String> parts = inputDateString.split(" ");
      int month = monthStringToNumber(parts[0]);
      int day = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      int hour = int.parse(parts[3].split(":")[0]);
      int minute = int.parse(parts[3].split(":")[1]);
      int second = int.parse(parts[3].split(":")[2]);

      DateTime dateTime = DateTime(year, month, day, hour, minute, second);
      return dateTime;
    }
  }

  static int monthStringToNumber(String monthString) {
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
        throw const FormatException("Invalid month string");
    }
  }

  factory Device.fromJson(Map<String, dynamic> json) => Device(
      macAdr: json["macAdr"] ?? "NA",
      devId: json["devId"] ?? "NA",
      installedOn: json["instOn"] == null
          ? DateTime.now()
          : convertToDate(json["instOn"]),
      battRem: json["battRem"] ?? 0.0,
      cupsRem: json["cupsRem"] ?? 0,
      liquidRem: json["washRem1"] ?? 0.0,
      lastUpdated: json["lstUpd"] == null
          ? DateTime.now()
          : convertToDate(json["lstUpd"]),
      timesRefilled: json["ref"] ?? 0,
      latlng: json["latlng"] ?? const GeoPoint(0, 0),
      address: json["address"],
      formattedAddress: json["formattedAddress"] ?? "Unknown Address",
      liquidRem2: json["washRem2"] ?? 0.0,
      installedBy: json["instBy"] ?? "unknown",
      history: json["history"] == null
          ? [
              History(
                  battRem: 0,
                  cupsRem: 0,
                  washRem1: 0,
                  washRem2: 0,
                  time: DateTime.now())
            ]
          : List<History>.from(json["history"].map((x) => History.fromJson(x))),
      lastRefilled:
          json["refOn"] == null ? DateTime.now() : convertToDate(json["refOn"]),
      wifiId: json["wifiId"] ?? "NA",
      wifiPass: json["wifiPass"] ?? "NA",
      deviceType: json["deviceType"] ?? "NA",
      clientAddress: json["deviceAddress"] ?? "NA",
      clientName: json["clientName"] ?? "NA",
      postCodePlace: json["postCode"] ?? "NA",
      floorInfo: json["floorDetails"] ?? "NA",
      cscDetails: json["cscDetails"] ?? "NA",
      contactPersonName: json["contactPr"] ?? "NA",
      contactPersonNumber: json["contactPrNo"] ?? "NA",
      clientNo: json["clientNo"] ?? "NA",
      deviceSerialNo: json["sNo"] ?? "NA");

  @override
  LatLng get location => LatLng(latlng.latitude, latlng.longitude);
}

class History {
  final num battRem;
  final num cupsRem;
  final num washRem1;
  final num washRem2;
  final DateTime time;

  History({
    required this.battRem,
    required this.cupsRem,
    required this.washRem1,
    required this.washRem2,
    required this.time,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        battRem: json["battRem"] ?? 0,
        cupsRem: json["cupsRem"] ?? 0,
        washRem1: json["washRem1"] ?? 0,
        washRem2: json["washRem2"] ?? 0,
        time:
            json["time"] == null ? DateTime.now() : convertToDate(json["time"]),
      );

  static DateTime convertToDate(String inputDateString) {
    if (inputDateString.isEmpty || inputDateString == null) {
      return DateTime(0000, 1, 0, 0, 0, 0);
    } else {
      List<String> parts = inputDateString.split(" ");
      int month = monthStringToNumber(parts[0]);
      int day = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      int hour = int.parse(parts[3].split(":")[0]);
      int minute = int.parse(parts[3].split(":")[1]);
      int second = int.parse(parts[3].split(":")[2]);

      DateTime dateTime = DateTime(year, month, day, hour, minute, second);
      return dateTime;
    }
  }

  static int monthStringToNumber(String monthString) {
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
        throw const FormatException("Invalid month string");
    }
  }
}
