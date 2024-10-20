import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/app_strings.dart';
import 'package:quickcare/constants/asset_constants.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/provider/custom_auth_provider.dart';
import 'package:quickcare/screens/web/authsignin.dart';
import 'package:quickcare/screens/web/mapscreen.dart';
import 'package:quickcare/widgets/web/create_acc_web_container.dart';

import 'package:quickcare/widgets/web/devices_tab.dart';
import 'package:quickcare/widgets/web/home_tab.dart';
import 'package:quickcare/widgets/web/live_data_tab.dart';

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  bool isHome = true;
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF353739),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 25.h),
        child: Row(
          children: [
            SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    width: 200.w,
                    child: Image.asset(
                      AssetConstants.splashScreenAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (currentTab != 0) {
                        currentTab = 0;
                        setState(() {});
                      } else {
                        null;
                      }
                    },
                    child: Text(
                      AppStrings.home,
                      style: TextStyle(
                        color: currentTab == 0
                            ? Colors.white
                            : DarkTheme.disabledWhite,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (currentTab != 1) {
                        currentTab = 1;
                        setState(() {});
                      } else {
                        null;
                      }
                    },
                    child: Text(
                      AppStrings.devices,
                      style: TextStyle(
                        color: currentTab == 1
                            ? DarkTheme.primaryWhite
                            : DarkTheme.disabledWhite,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (currentTab != 2) {
                        currentTab = 2;
                        setState(() {});
                      } else {
                        null;
                      }
                    },
                    child: Text(
                      AppStrings.live_data,
                      style: TextStyle(
                        color: currentTab == 2
                            ? DarkTheme.primaryWhite
                            : DarkTheme.disabledWhite,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(
                            afterMapLoad: () {},
                          ),
                        ),
                      );
                    },
                    child: Text(
                      AppStrings.getAMapView,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isHome ? Colors.white : DarkTheme.disabledWhite,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.only(bottom: 56.h),
                    child: TextButton(
                      onPressed: () async {
                        currentTab = 3;
                        setState(() {});
                      },
                      child: Text(
                        AppStrings.createAccount,
                        style: TextStyle(
                            color: Colors.white.withOpacity(.7),
                            fontSize: 20.sp),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 56.h),
                    child: TextButton(
                      onPressed: () async {
                        var isSignedOut = await Provider.of<CustomAuthProvider>(
                                context,
                                listen: false)
                            .signOut(context);
                      },
                      child: Text(
                        AppStrings.logOut,
                        style: TextStyle(
                            color: Colors.white.withOpacity(.7),
                            fontSize: 20.sp),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 42.w,
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 57.w,
                    vertical: 40.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0XFF1C1D21),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: currentTab == 0
                      ? const HomeTab()
                      : currentTab == 1
                          ? const DevicesTab()
                          : currentTab == 2
                              ? const LiveDataTab()
                              : CreateAccountWebContainer()),
            ),
          ],
        ),
      ),
    );
  }
}
