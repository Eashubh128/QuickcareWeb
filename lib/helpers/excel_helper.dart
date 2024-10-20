import 'package:intl/intl.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'dart:html' as html;

class ExcelHelper {
  static Future<void> createExcelFile(
      List<Device> devices, DateTime startDate, DateTime endDate,
      {bool isInvoicing = false}) async {
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
    List<String> detailedHeaders = [
      'Device ID',
      'Ref',
      'RefOn',
      'Installed By',
      'Installed On',
      'Address',
      'Time of usage',
      'Battery Rem',
      'Cups left',
      'Liquid 1',
      'Liquid 2',
      'MAC Address',
      'Latitude',
      'Longitude',
      'Last Updated',
      'WiFi ID',
      'WiFi Password',
      'Client Name',
      'Client Address',
      'Floor Info',
      'Postcode Place',
      'Device Model',
      'CSC Details',
      'Contact Person Name',
      'Contact Person Number'
    ];
    List<String> invoiceHeaders = [
      'Device Model',
      "SerialNo",
      "ClientNo",
      'Client Name',
      'Client Address',
      'Floor',
      "Add. Information",
      "Postcode (Place)",
      "City",
      "Cups Level Start",
      "Cups Refilled",
      "Number of Cups Refilled",
      "Cup Level End",
      "Cups Used",
      "Liquid Level Start",
      "Liquid Refilled",
      "Number of Liquid Refilled",
      "Liquid Level End",
      "Liquid Used",
      "Battery Level Start",
      "Battery Level End"
    ];
    List<String> headers = detailedHeaders;

    if (isInvoicing) {
      headers = invoiceHeaders;
    }

    for (int i = 0; i < headers.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
    }

    int currentRow = 2;
    if (!isInvoicing) {
      for (Device device in devices) {
        sheet.getRangeByIndex(currentRow, 1).setText(device.devId);
        sheet
            .getRangeByIndex(currentRow, 2)
            .setNumber(device.timesRefilled.toDouble());
        sheet
            .getRangeByIndex(currentRow, 3)
            .setText(device.lastRefilled.toString());
        sheet.getRangeByIndex(currentRow, 4).setText(device.installedBy);
        sheet
            .getRangeByIndex(currentRow, 5)
            .setText(device.installedOn.toString());
        sheet.getRangeByIndex(currentRow, 6).setText(device.formattedAddress);

        int col = 12;
        sheet.getRangeByIndex(currentRow, col++).setText(device.macAdr);
        sheet
            .getRangeByIndex(currentRow, col++)
            .setNumber(device.latlng.latitude);
        sheet
            .getRangeByIndex(currentRow, col++)
            .setNumber(device.latlng.longitude);
        sheet
            .getRangeByIndex(currentRow, col++)
            .setText(device.lastUpdated.toString());
        sheet.getRangeByIndex(currentRow, col++).setText(device.wifiId);
        sheet.getRangeByIndex(currentRow, col++).setText(device.wifiPass);
        sheet.getRangeByIndex(currentRow, col++).setText(device.clientName);
        sheet.getRangeByIndex(currentRow, col++).setText(device.clientAddress);
        sheet.getRangeByIndex(currentRow, col++).setText(device.floorInfo);
        sheet.getRangeByIndex(currentRow, col++).setText(device.postCodePlace);
        sheet.getRangeByIndex(currentRow, col++).setText(device.deviceType);
        sheet.getRangeByIndex(currentRow, col++).setText(device.cscDetails);
        sheet
            .getRangeByIndex(currentRow, col++)
            .setText(device.contactPersonName);
        sheet
            .getRangeByIndex(currentRow, col++)
            .setText(device.contactPersonNumber);

        List<History> filteredHistory = device.history.where((history) {
          return history.time.isAfter(startDate) &&
              history.time.isBefore(endDate);
        }).toList();

        for (History history in filteredHistory) {
          sheet.getRangeByIndex(currentRow, 7).setText(history.time.toString());
          sheet
              .getRangeByIndex(currentRow, 8)
              .setNumber(history.battRem.toDouble());
          sheet
              .getRangeByIndex(currentRow, 9)
              .setNumber(history.cupsRem.toDouble());
          sheet
              .getRangeByIndex(currentRow, 10)
              .setNumber(history.washRem1.toDouble());
          sheet
              .getRangeByIndex(currentRow, 11)
              .setNumber(history.washRem2.toDouble());
          currentRow++;
        }
        if (filteredHistory.isEmpty) {
          currentRow++;
        }
      }
    } else {
      // for Invoicing
      for (Device device in devices) {
        int cupsLevelStart = 0;
        int cupsLevelEnd = 0;
        int cupsUsedInGivenTime = 0;
        double liquidLevelStart = 0;
        double liquidLevelEnd = 0;
        double batteryLevelStart = 0;
        double batteryLevelEnd = 0;
        double liquidUsedInGivenTime = 0;
        String city = device.cscDetails.split(",").lastOrNull ?? "No info";

        List<History> filteredHistory = device.history.where((history) {
          return history.time.isAfter(startDate) &&
              history.time.isBefore(endDate);
        }).toList();

        if (filteredHistory.isNotEmpty) {
          cupsLevelStart = filteredHistory.first.cupsRem.toInt();
          cupsLevelEnd = filteredHistory.last.cupsRem.toInt();
          liquidLevelStart = filteredHistory.first.washRem1.toDouble();
          liquidLevelEnd = filteredHistory.first.washRem1.toDouble();
          batteryLevelStart = filteredHistory.first.battRem.toDouble();
          batteryLevelEnd = filteredHistory.last.battRem.toDouble();
          cupsUsedInGivenTime = filteredHistory.length;
          liquidUsedInGivenTime = filteredHistory.length * 15;
        }

        sheet.getRangeByIndex(currentRow, 1).setText(device.deviceType);
        sheet.getRangeByIndex(currentRow, 2).setText(device.deviceSerialNo);
        sheet.getRangeByIndex(currentRow, 3).setText(device.clientNo);
        sheet.getRangeByIndex(currentRow, 4).setText(device.clientName);
        sheet.getRangeByIndex(currentRow, 5).setText(device.clientAddress);
        sheet.getRangeByIndex(currentRow, 6).setText(device.floorInfo);
        sheet.getRangeByIndex(currentRow, 7).setText("");
        sheet.getRangeByIndex(currentRow, 8).setText(device.postCodePlace);
        sheet.getRangeByIndex(currentRow, 9).setText(city);
        sheet
            .getRangeByIndex(currentRow, 10)
            .setText(cupsLevelStart.toString());
        sheet.getRangeByIndex(currentRow, 11).setText("No info");
        sheet.getRangeByIndex(currentRow, 12).setText("No info");
        sheet.getRangeByIndex(currentRow, 13).setText(cupsLevelEnd.toString());
        sheet
            .getRangeByIndex(currentRow, 14)
            .setText(cupsUsedInGivenTime.toString());
        sheet
            .getRangeByIndex(currentRow, 15)
            .setText(liquidLevelStart.toString());
        sheet.getRangeByIndex(currentRow, 16).setText("No info");
        sheet.getRangeByIndex(currentRow, 17).setText("No info");
        sheet
            .getRangeByIndex(currentRow, 18)
            .setText(liquidLevelEnd.toString());
        sheet
            .getRangeByIndex(currentRow, 19)
            .setText(liquidUsedInGivenTime.toString());
        sheet
            .getRangeByIndex(currentRow, 20)
            .setText(batteryLevelStart.toString());
        sheet
            .getRangeByIndex(currentRow, 21)
            .setText(batteryLevelEnd.toString());

        if (filteredHistory.isEmpty) {
          currentRow++;
        }
      }
    }

    for (int i = 1; i <= headers.length; i++) {
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();

    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download =
          '${!isInvoicing ? "Regular_" : "Invoicing_"}Devices${DateFormat.yMMMMd('en_US').format(startDate)}"_"${DateFormat.yMMMMd('en_US').format(endDate)}.xlsx';
    html.document.body?.children.add(anchor);
    anchor.click();

    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
