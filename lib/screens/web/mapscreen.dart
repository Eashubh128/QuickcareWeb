import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/app_strings.dart';
import 'package:quickcare/constants/asset_constants.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:quickcare/provider/deviceslistprovider.dart';
import 'package:quickcare/provider/themeprovider.dart';
import 'package:quickcare/widgets/web/devices_map_tile.dart';

late GoogleMapController googleMapController;

class MapPage extends StatefulWidget {
  MapPage({super.key, required this.afterMapLoad});
  Function afterMapLoad;
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String _darkMapStyle = "";
  String _lightMapStyle = "";

  List<Device> _searchedDevices = [];

  final TextEditingController searchDevicesController = TextEditingController();

  List<String> markerFilterBy = [
    AppStrings.battery,
    AppStrings.cups,
    AppStrings.liquid
  ];
  String dropDownValue = "";

  Set<Marker> _myMarkers = {};

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(46.62437406920402, 8.04515382700661),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    dropDownValue = markerFilterBy.first;
    _loadMarkers();
  }

  Future<void> getLocation() async {
    LocationData currentLocation;
    currentLocation = await Location.instance.getLocation();
    bool isUpdated = false;
    // log("Updating camera position ${currentLocation.latitude} ${currentLocation.longitude}");
    try {
      await googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 13.5,
          ),
        ),
      );
      isUpdated = true;
    } catch (e) {
      log(e.toString());
      isUpdated = false;
    } finally {
      if (!isUpdated) {
        await Future.delayed(const Duration(microseconds: 200));
        await googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
              zoom: 13.5,
            ),
          ),
        );
      }
    }
  }

  Future<void> _loadMarkers() async {
    Set<Marker> markers = {};
    for (var element in Provider.of<DevicesListProvider>(context, listen: false)
        .devicesList) {
      BitmapDescriptor markerIcon;
      if (dropDownValue.toLowerCase() == AppStrings.battery.toLowerCase()) {
        markerIcon =
            await getMarkerFromValue(element.history.lastOrNull?.battRem ?? 0);
      } else if (dropDownValue.toLowerCase() ==
          AppStrings.liquid.toLowerCase()) {
        markerIcon =
            await getMarkerFromValue(element.history.lastOrNull?.washRem1 ?? 0);
      } else {
        markerIcon =
            await getMarkerFromValue(element.history.lastOrNull?.cupsRem ?? 0);
      }

      markers.add(Marker(
        markerId: MarkerId(element.devId),
        position: LatLng(element.latlng.latitude, element.latlng.longitude),
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: element.devId,
          snippet:
              "Batt: ${element.history.lastOrNull?.battRem ?? 0} % \nCups Rem: ${element.history.lastOrNull?.cupsRem ?? 0}",
        ),
      ));
    }

    setState(() {
      _myMarkers = markers;
    });
  }

  Future<BitmapDescriptor> getImage(String assetPath) async {
    final asset = await rootBundle.load(assetPath);
    final icon = BitmapDescriptor.fromBytes(asset.buffer.asUint8List(),
        size: const Size(50, 50));
    return icon;
  }

  void _filterDevices(String query) {
    final devices =
        Provider.of<DevicesListProvider>(context, listen: false).devicesList;
    setState(() {
      _searchedDevices = devices
          .where((device) =>
              device.devId.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0XFF353739),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    left: 32.w, right: 32.w, top: 5.h, bottom: 5.h),
                itemBuilder: (context, index) {
                  if (_searchedDevices.isEmpty) {
                    _searchedDevices =
                        Provider.of<DevicesListProvider>(context).devicesList;
                  }

                  if (index == 0) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF1C1D21),
                          fixedSize: Size(300.w, 40.h),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(6.w))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppStrings.toDevicesPage,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    );
                  } else {
                    return DeviceMapTile(
                        deviceDetails: _searchedDevices.elementAt(index - 1));
                  }
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 8.h,
                  );
                },
                itemCount: _searchedDevices.isEmpty
                    ? Provider.of<DevicesListProvider>(context)
                            .devicesList
                            .length +
                        1
                    : _searchedDevices.length + 1,
              ),
            ),
            Container(
              height: 853.h,
              width: 900.w,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
              decoration: BoxDecoration(
                color: const Color(0XFF1C1D21),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, snapshot) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(14.w),
                        child: GoogleMap(
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          markers: _myMarkers,
                          onMapCreated: (controller) async {
                            googleMapController = controller;

                            await getLocation();
                            widget.afterMapLoad;
                            setState(() {});
                          },
                          initialCameraPosition: _initialCameraPosition,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      decoration: const BoxDecoration(color: Color(0XFF1C1D21)),
                      child: DropdownMenu<String>(
                        textStyle: const TextStyle(color: Colors.white),
                        enableSearch: false,
                        enableFilter: false,
                        initialSelection: markerFilterBy.first,
                        onSelected: (value) {
                          dropDownValue = value!;
                          _loadMarkers();
                          setState(() {});
                        },
                        dropdownMenuEntries: markerFilterBy.map((filter) {
                          return DropdownMenuEntry(
                              value: filter,
                              label: filter,
                              style: const ButtonStyle(
                                  foregroundColor:
                                      WidgetStatePropertyAll(Colors.white),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Color(0XFF1C1D21))));
                        }).toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: SizedBox(
                      width: 200.w,
                      child: TextField(
                        controller: searchDevicesController,
                        style: TextStyle(
                          color: DarkTheme.primaryWhite,
                          fontSize: 15.sp,
                        ),
                        decoration: InputDecoration(
                          enabled: true,
                          isDense: true,
                          filled: true,
                          hintText: AppStrings.search,
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                          fillColor: const Color(0XFF1C1D21),
                          contentPadding: const EdgeInsets.all(15),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xFFD5D5D5),
                            ),
                            borderRadius: BorderRadius.circular(30.w),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xFFD5D5D5),
                            ),
                            borderRadius: BorderRadius.circular(30.w),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xFFD5D5D5),
                            ),
                            borderRadius: BorderRadius.circular(30.w),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filterDevices(value);
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20.h,
                      right: 30.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 50),
                          backgroundColor:
                              Provider.of<ThemeProvider>(context).isDarkTheme
                                  ? DarkTheme.secondaryBackground
                                  : LightTheme.secondaryBackground,
                          shape: const CircleBorder(side: BorderSide()),
                        ),
                        onPressed: () async {
                          await getLocation();
                        },
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 30,
                          color: Provider.of<ThemeProvider>(context).isDarkTheme
                              ? DarkTheme.primaryWhite
                              : LightTheme.textColorPrimary,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<BitmapDescriptor> getMarkerFromValue(num value) async {
    if (value < 21) {
      var marker = await getImage(AssetConstants.redMapMarker);
      return marker;
    }
    if (value < 51 && value > 21) {
      var marker = await getImage(AssetConstants.yellowMapMarker);
      return marker;
    }
    var marker = await getImage(AssetConstants.greenMapMarker);
    return marker;
  }
}
