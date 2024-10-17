import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/constants/asset_constants.dart';
import 'package:quickcare/constants/color_constants.dart';
import 'package:quickcare/provider/custom_auth_provider.dart';
import 'package:quickcare/provider/loginprovider.dart';
import 'package:quickcare/screens/web/authsignin.dart';
import 'package:quickcare/screens/web/homescreen_web.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        final authProvider =
            Provider.of<CustomAuthProvider>(context, listen: false);

        if (authProvider.currentUser == null) {
          GoRouter.of(context).go('/signin');
        } else {
          GoRouter.of(context).go('/home');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DarkTheme.primaryWhite,
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: Image(
          image: const AssetImage(
            AssetConstants.splashScreenAsset,
          ),
          width: 400.w,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
