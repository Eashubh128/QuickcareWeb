import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/models/devicemodel.dart';
import 'package:quickcare/provider/deviceslistprovider.dart';
import 'package:quickcare/provider/themeprovider.dart';

class DeviceDetailTile extends StatelessWidget {
  DeviceDetailTile({super.key, required this.device});

  Device device;

  @override
  Widget build(BuildContext context) {
    final deviceListProvider =
        Provider.of<DevicesListProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        deviceListProvider.setSelectedDevice(device);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: deviceListProvider.selectedDevice?.devId == device.devId
                ? const Color.fromARGB(67, 4, 96, 255)
                : Provider.of<ThemeProvider>(context).isDarkTheme
                    ? DarkTheme.secondaryBackground
                    : LightTheme.secondaryBackground,
            border: Border.all(
              color: DarkTheme.primaryBorder,
            ),
            borderRadius: BorderRadius.circular(350)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 105.w,
              child: Text(
                "${device.devId} (${device.deviceType.toLowerCase() == "automatic" ? "Auto" : device.deviceType.toLowerCase() == "semi-automatic" ? "Semi-Auto" : "Manual"}) ",
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).isDarkTheme
                      ? DarkTheme.primaryWhite
                      : LightTheme.textColorPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              width: 300.w,
              child: Text(
                device.formattedAddress,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Provider.of<ThemeProvider>(context).isDarkTheme
                      ? DarkTheme.primaryWhite
                      : LightTheme.textColorPrimary,
                ),
              ),
            ),
            SizedBox(
                width: 90.w,
                height: 35.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${device.history.last.battRem} %",
                      style: TextStyle(
                        color: Provider.of<ThemeProvider>(context).isDarkTheme
                            ? (device.history.last.battRem) > 51
                                ? DarkTheme.primaryGreen
                                : (device.history.last.battRem) < 21
                                    ? DarkTheme.primaryRed
                                    : Colors.yellow
                            : LightTheme.textColorPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.battery_6_bar_outlined,
                      color: Provider.of<ThemeProvider>(context).isDarkTheme
                          ? (device.history.last.battRem) > 51
                              ? DarkTheme.primaryGreen
                              : (device.history.last.battRem) < 21
                                  ? DarkTheme.primaryRed
                                  : Colors.yellow
                          : LightTheme.textColorPrimary,
                    )
                  ],
                )),
            SizedBox(
                width: 90.w,
                height: 35.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${device.history.last.cupsRem}/${device.deviceType.toLowerCase() == "automatic" ? 200 : 100}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.local_drink_outlined,
                      color: DarkTheme.primaryBlue,
                    )
                  ],
                )),
            SizedBox(
              width: 90.w,
              height: 35.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${device.history.last.washRem1} %",
                    style: TextStyle(
                      color: Provider.of<ThemeProvider>(context).isDarkTheme
                          ? (device.history.last.washRem1) > 51
                              ? DarkTheme.primaryGreen
                              : (device.history.last.washRem1) < 21
                                  ? DarkTheme.primaryRed
                                  : Colors.yellow
                          : LightTheme.textColorPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.water_drop_outlined,
                    color: DarkTheme.primaryPurple,
                  )
                ],
              ),
            ),
            SizedBox(
              width: 90.w,
              height: 35.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${device.timesRefilled}",
                    style: TextStyle(
                      color: Provider.of<ThemeProvider>(context).isDarkTheme
                          ? DarkTheme.primaryWhite
                          : LightTheme.textColorPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.refresh,
                    color: DarkTheme.primaryPurple,
                  )
                ],
              ),
            ),
            Visibility(
              visible: device.deviceType.toLowerCase() == "automatic",
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${device.history.last.washRem2}%",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Provider.of<ThemeProvider>(context).isDarkTheme
                            ? (device.history.last.washRem2) > 51
                                ? DarkTheme.primaryGreen
                                : (device.history.last.washRem2) < 21
                                    ? DarkTheme.primaryRed
                                    : Colors.yellow
                            : LightTheme.textColorPrimary,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    const Icon(
                      Icons.water_drop_outlined,
                      color: Colors.orange,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
