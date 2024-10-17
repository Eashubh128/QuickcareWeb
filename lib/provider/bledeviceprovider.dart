import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickcare/constants/bluetooth_characteristics.dart';

class BleDeviceProvider extends ChangeNotifier {
  BluetoothDevice? _connectedDevice;
  bool isScanning = false;
  bool isConnecting = false;
  List<BluetoothService> _services = [];
  List<BluetoothCharacteristic> _characteristics = [];
  Map<Guid, BluetoothCharacteristic> _characteristicMap = {};

  Future<void> scanAndConnect() async {
    try {
      var adapterState = await FlutterBluePlus.adapterState.first;
      //FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

      Timer? scanTimer;

      if (adapterState == BluetoothAdapterState.on) {
        log("Asking for permission");
        var permissionStatus = await askForPermission();

        isScanning = true;
        notifyListeners();
        if (permissionStatus) {
          log("Permission given");
          FlutterBluePlus.scanResults.listen(
            (event) async {
              log("Scanning");
              if (event.isNotEmpty) {
                log("Scanned Device::::${event.elementAt(0).device.advName}}");
                var scannedDevice = event.elementAt(0).device;
                scanTimer!.cancel();
                await FlutterBluePlus.stopScan();
                await connectToDevice(scannedDevice);
              }
            },
            onDone: () {
              log("Scanning Done");
              isScanning = false;

              notifyListeners();
            },
          );
          await FlutterBluePlus.startScan(
            withServices: [
              BleUUID.SERVICE_ID,
            ],
            // androidUsesFineLocation: true,
          );
          scanTimer = Timer(const Duration(seconds: 10), () async {
            await FlutterBluePlus.stopScan();
            isScanning = false;

            notifyListeners();
          });
        } else {
          log("Permission were not given");
          throw ("Permissions were not given");
        }
      } else {
        // Fluttertoast.showToast(msg: "Please turn on bluetooth");
      }
    } catch (e) {}
  }

  Future connectToDevice(BluetoothDevice device) async {
    try {
      var adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState == BluetoothAdapterState.on && isConnecting == false) {
        log("Connecting to device");
        bool gotServices = false;
        isConnecting = true;
        isScanning = false;
        notifyListeners();
        await device.connect(autoConnect: true);

        gotServices = await discoverServices(device);
        gotServices ? _connectedDevice = device : null;
        notifyListeners();
      } else {
        // Fluttertoast.showToast(msg: "Please turn on bluetooth");
      }
    } catch (e) {
      log("error ocurred in connecting to device ${e.toString()}");
    }
  }

  Future<bool> discoverServices(BluetoothDevice device) async {
    try {
      _services = await device.discoverServices();
      _characteristicMap.clear();
      _characteristics = _services
          .where((element) => element.uuid == BleUUID.SERVICE_ID)
          .first
          .characteristics;
      for (var element in _characteristics) {
        _characteristicMap.putIfAbsent(element.uuid, () => element);
        log("${element.toString}");
      }
      notifyListeners();
      return true;
    } catch (e) {
      // Fluttertoast.showToast(msg: "Couldnt get services");
      return false;
    }
  }

  Future<bool> sendToDevice(String command, Guid characteristics) async {
    try {
      var adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState == BluetoothAdapterState.on) {
        BluetoothCharacteristic? writeTarget =
            _characteristicMap[characteristics];
        await writeTarget!.write(command.codeUnits);
        return true;
      } else {
        // Fluttertoast.showToast(msg: "Please turn on bluetooth");
        return false;
      }
    } catch (e) {
      log(
        "error in sending message ${e.toString}",
      );
      return false;
    }
  }

  Future<void> listenMouthWashValues() async {
    try {
      var adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState == BluetoothAdapterState.on) {
        BluetoothCharacteristic? readTarget =
            _characteristicMap[BleUUID.MOUTHWASH_ID];
        readTarget!.lastValueStream.listen((event) {
          String data = String.fromCharCodes(event);
          print("Recieved Data $data");
        });

        await readTarget.setNotifyValue(true);
      }
    } catch (e) {
      log("Error ocurred in listenMouthWashValues ${e.toString()}");
    }
  }

  Future<bool> askForPermission() async {
    try {
      final locationPermissionStatus = await Permission.location.isGranted;
      final bluetoothPermissionStatus = await Permission.bluetooth.isGranted;
      if (locationPermissionStatus && bluetoothPermissionStatus) {
        return true;
      } else {
        if (!locationPermissionStatus) {
          await Permission.location.request();
        } else {
          await Permission.bluetooth.request();
        }
      }
      var locationPermissionAfterRequest = await Permission.location.status;
      var bluetoothPermissionAfterRequest = await Permission.bluetooth.status;
      if (locationPermissionAfterRequest.isGranted &&
          bluetoothPermissionAfterRequest.isGranted) {
        return true;
      } else {
        locationPermissionAfterRequest = await Permission.location.request();
        bluetoothPermissionAfterRequest = await Permission.bluetooth.request();
        if (locationPermissionAfterRequest.isGranted &&
            bluetoothPermissionAfterRequest.isGranted) {
          return false;
        }
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
