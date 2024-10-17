import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:quickcare/provider/themeprovider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:quickcare/screens/web/mapscreen.dart';
import 'package:quickcare/widgets/web/icon_text_pair.dart';

class DeviceMapTile extends StatefulWidget {
  const DeviceMapTile({super.key, required this.deviceDetails});

  final Device deviceDetails;

  @override
  State<DeviceMapTile> createState() => _DeviceMapTileState();
}

class _DeviceMapTileState extends State<DeviceMapTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(widget.deviceDetails.latlng.latitude,
                    widget.deviceDetails.latlng.longitude),
                zoom: 20.5,
              ),
            ),
          );
        } catch (e) {
          Fluttertoast.showToast(msg: "Sorry , cannot take you there yet");
        }
      },
      child: badges.Badge(
        position: badges.BadgePosition.topEnd(),
        showBadge: showBadge(),
        ignorePointer: false,
        onTap: () {},
        badgeContent:
            Icon(Icons.priority_high, color: Colors.white, size: 22.w),
        badgeStyle: badges.BadgeStyle(
          shape: badges.BadgeShape.circle,
          badgeColor: DarkTheme.primaryRed,
          padding: EdgeInsets.all(5.w),
          borderRadius: BorderRadius.circular(4.w),
          borderSide: BorderSide(color: Colors.white, width: 2.w),
          elevation: 5,
        ),
        child: Container(
          width: 311.w,
          height: 210.h,
          decoration: BoxDecoration(
            color: Provider.of<ThemeProvider>(context).isDarkTheme
                ? DarkTheme.secondaryBackground
                : LightTheme.primaryWhite,
            borderRadius: BorderRadius.circular(6),
            boxShadow: getBoxShadow(),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.deviceDetails.devId,
                          style: TextStyle(
                              color: Provider.of<ThemeProvider>(context)
                                      .isDarkTheme
                                  ? DarkTheme.primaryWhite
                                  : LightTheme.textColorPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.deviceDetails.deviceType,
                          style: TextStyle(
                              color: Provider.of<ThemeProvider>(context)
                                      .isDarkTheme
                                  ? DarkTheme.primaryWhite
                                  : LightTheme.textColorPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: Text(
                  widget.deviceDetails.clientName,
                  maxLines: 1,
                  style: TextStyle(
                      color: Provider.of<ThemeProvider>(context).isDarkTheme
                          ? DarkTheme.primaryWhite
                          : LightTheme.textColorPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: Text(
                  widget.deviceDetails.clientAddress,
                  maxLines: 2,
                  style: TextStyle(
                      color: Provider.of<ThemeProvider>(context).isDarkTheme
                          ? DarkTheme.primaryWhite
                          : LightTheme.textColorPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: Text(
                  widget.deviceDetails.floorInfo,
                  maxLines: 1,
                  style: TextStyle(
                      color: Provider.of<ThemeProvider>(context).isDarkTheme
                          ? DarkTheme.primaryWhite
                          : LightTheme.textColorPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: Text(
                  widget.deviceDetails.postCodePlace,
                  maxLines: 1,
                  style: TextStyle(
                      color: Provider.of<ThemeProvider>(context).isDarkTheme
                          ? DarkTheme.primaryWhite
                          : LightTheme.textColorPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  clipBehavior: Clip.antiAlias,
                  children: [
                    IconTextPair(
                      text: "${widget.deviceDetails.history.last.battRem} %",
                      icon: Icons.battery_full_outlined,
                      iconColor:
                          (widget.deviceDetails.history.last.battRem) > 51
                              ? DarkTheme.primaryGreen
                              : (widget.deviceDetails.history.last.battRem) < 21
                                  ? DarkTheme.primaryRed
                                  : Colors.yellow,
                      textStyle: TextStyle(
                        color: Provider.of<ThemeProvider>(context).isDarkTheme
                            ? DarkTheme.primaryWhite
                            : LightTheme.textColorPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    IconTextPair(
                      text:
                          "${widget.deviceDetails.history.last.cupsRem}/${widget.deviceDetails.deviceType.toLowerCase() == "automatic" ? "200" : "100"}",
                      icon: Icons.local_drink_outlined,
                      iconColor: const Color(0XFF32A7E2),
                      textStyle: TextStyle(
                        color: Provider.of<ThemeProvider>(context).isDarkTheme
                            ? DarkTheme.primaryWhite
                            : LightTheme.textColorPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    IconTextPair(
                      text: "${widget.deviceDetails.history.last.washRem1} %",
                      icon: Icons.water_drop_outlined,
                      iconColor: const Color(0XFFA23ED0),
                      textStyle: TextStyle(
                        color: Provider.of<ThemeProvider>(context).isDarkTheme
                            ? DarkTheme.primaryWhite
                            : LightTheme.textColorPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<BoxShadow> getBoxShadow() {
    if (widget.deviceDetails.history.last.cupsRem <= 15 ||
        widget.deviceDetails.history.last.battRem <= 10 ||
        widget.deviceDetails.history.last.washRem1 <= 10) {
      return [
        const BoxShadow(
          color: DarkTheme.primaryRed,
          offset: Offset(0, 0),
          blurRadius: 7,
          spreadRadius: 1,
        ),
      ];
    } else {
      return [];
    }
  }

  bool showBadge() {
    if (widget.deviceDetails.history.last.cupsRem <= 15 ||
        widget.deviceDetails.history.last.battRem <= 10 ||
        widget.deviceDetails.history.last.washRem1 <= 10) {
      return true;
    } else {
      return false;
    }
  }
}
